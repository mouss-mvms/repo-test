require 'rails_helper'

RSpec.describe Api::V1::Shops::SchedulesController do

  describe 'GET #index' do
    context 'All ok' do
      it 'should return 200 HTTP Status with schedules of shop' do
        shop = create(:shop)

        get :index, params: { id: shop.id }

        expect(response).to have_http_status(:ok)
        result = JSON.parse(response.body)
        expect(result.count).to eq(shop.schedules.count)
      end

      it 'should return 304 HTTP Status' do
        shop = create(:shop)
        get :index, params: { id: shop.id }
        expect(response).to have_http_status(:ok)

        etag = response.headers["ETag"]
        request.env["HTTP_IF_NONE_MATCH"] = etag

        get :index, params: { id: shop.id }
        expect(response).to have_http_status(304)
      end
    end

    context 'Shop not found' do
      it 'should return 404 HTTP Status' do

        get :index, params: { id: 0 }

        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Shop with 'id'=#{response.request.params[:id]}").to_h.to_json)
      end
    end
  end

  describe 'PUT #update' do
    def generate_schedule_param(schedule_id, open_morning, open_afternoon, close_morning, close_afternoon)
      {
        id: schedule_id,
        openMorning: open_morning,
        openAfternoon: open_afternoon,
        closeMorning: close_morning,
        closeAfternoon: close_afternoon,
      }
    end

    context 'All ok' do
      it 'should return 200 HTTP status with updated schedules' do
        shop = create(:shop)
        user_shop_employee = create(:shop_employee_user)
        user_shop_employee.shop_employee.shops << shop
        user_shop_employee.shop_employee.save
        params = [
          generate_schedule_param(shop.schedules[0].id, "09:00", "14:00", "12:00", "19:00"),
          generate_schedule_param(shop.schedules[1].id, "09:00", "14:00", "12:00", "19:00"),
          generate_schedule_param(shop.schedules[2].id, "09:00", "14:00", "12:00", "19:00"),
          generate_schedule_param(shop.schedules[3].id, "09:00", "14:00", "12:00", "19:00"),
          generate_schedule_param(shop.schedules[4].id, "09:00", "14:00", "12:00", "19:00"),
          generate_schedule_param(shop.schedules[5].id, "08:00", "14:00", "12:00", "19:00"),
          generate_schedule_param(shop.schedules[6].id, nil, nil, nil, nil)
        ]

        request.headers['x-client-id'] = generate_token(user_shop_employee)

        put :update, params: {id: shop.id, _json: params}

        expect(response).to have_http_status(:ok)
        result = JSON.parse(response.body)
        expect(result.count).to eq(shop.schedules.count)
        result.each_with_index do |r, index|
          expect(r['id']).to eq(params[index][:id])
          schedule_updated = ::Schedule.find(r['id'])
          expect(r['openMorning']).to eq(params[index][:openMorning])
          expect(schedule_updated.am_open&.strftime('%H:%M')).to eq(params[index][:openMorning])
          expect(r['openAfternoon']).to eq(params[index][:openAfternoon])
          expect(schedule_updated.pm_open&.strftime('%H:%M')).to eq(params[index][:openAfternoon])
          expect(r['closeMorning']).to eq(params[index][:closeMorning])
          expect(schedule_updated.am_close&.strftime('%H:%M')).to eq(params[index][:closeMorning])
          expect(r['closeAfternoon']).to eq(params[index][:closeAfternoon])
          expect(schedule_updated.pm_close&.strftime('%H:%M')).to eq(params[index][:closeAfternoon])
        end
      end
    end

    context 'Bad authentication' do
      context 'x-client-id is missing' do
        it 'should return 401 HTTP Status' do
          shop = create(:shop)
          params = [
            generate_schedule_param(shop.schedules[0].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[1].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[2].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[3].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[4].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[5].id, "08:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[6].id, nil, nil, nil, nil)
          ]

          put :update, params: {id: shop.id, _json: params}

          expect(response).to have_http_status(:unauthorized)
          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context 'User not found' do
        it 'should return 403 HTTP Status' do
          user_citizen = create(:citizen_user)
          shop = create(:shop)
          params = [
            generate_schedule_param(shop.schedules[0].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[1].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[2].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[3].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[4].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[5].id, "08:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[6].id, nil, nil, nil, nil)
          ]
          User.destroy_all

          request.headers['x-client-id'] = generate_token(user_citizen)

          put :update, params: {id: shop.id, _json: params}

          expect(response).to have_http_status(:forbidden)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)

        end
      end

      context 'User is not a shop employee' do
        it 'should return 403 HTTP Status' do
          user_citizen = create(:citizen_user)
          shop = create(:shop)
          params = [
            generate_schedule_param(shop.schedules[0].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[1].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[2].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[3].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[4].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[5].id, "08:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[6].id, nil, nil, nil, nil)
          ]

          request.headers['x-client-id'] = generate_token(user_citizen)

          put :update, params: {id: shop.id, _json: params}

          expect(response).to have_http_status(:forbidden)
          expect(response.body).to eq(Dto::Errors::Forbidden.new('').to_h.to_json)

        end
      end

      context 'User is a shop employee but not the owner of the shop' do
        it 'should return 403 HTTP status' do
          user_shop_employee = create(:shop_employee_user)
          shop = create(:shop)
          params = [
            generate_schedule_param(shop.schedules[0].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[1].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[2].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[3].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[4].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[5].id, "08:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[6].id, nil, nil, nil, nil)
          ]

          request.headers['x-client-id'] = generate_token(user_shop_employee)

          put :update, params: {id: shop.id, _json: params}

          expect(response).to have_http_status(:forbidden)
          expect(response.body).to eq(Dto::Errors::Forbidden.new('').to_h.to_json)

        end
      end
    end

    context 'Bad params' do
      context 'Shop not found' do
        it 'should return 404 HTTP status' do
          user_shop_employee = create(:shop_employee_user)
          shop = create(:shop)
          params = [
            generate_schedule_param(shop.schedules[0].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[1].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[2].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[3].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[4].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[5].id, "08:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[6].id, nil, nil, nil, nil)
          ]
          Shop.destroy_all

          request.headers['x-client-id'] = generate_token(user_shop_employee)

          put :update, params: {id: shop.id, _json: params}

          expect(response).to have_http_status(:not_found)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Shop with 'id'=#{shop.id}").to_h.to_json)

        end
      end

      context 'Id is missing in object request schedule body' do
        it 'should return 400 HTTP Status' do
          user_shop_employee = create(:shop_employee_user)
          shop = create(:shop)
          user_shop_employee.shop_employee.shops << shop
          user_shop_employee.shop_employee.save
          params = [
            generate_schedule_param(shop.schedules[0].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[1].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(nil, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[3].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[4].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[5].id, "08:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[6].id, nil, nil, nil, nil)
          ]

          request.headers['x-client-id'] = generate_token(user_shop_employee)

          put :update, params: {id: shop.id, _json: params}

          expect(response).to have_http_status(:bad_request)
          expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: id").to_h.to_json)
        end
      end

      context 'Id of schedule requested is not a schedule of the shop' do
        it 'should return 404 HTTP Status' do
          user_shop_employee = create(:shop_employee_user)
          shop = create(:shop)
          user_shop_employee.shop_employee.shops << shop
          user_shop_employee.shop_employee.save
          schedule = create(:schedule)
          params = [
            generate_schedule_param(shop.schedules[0].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[1].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[2].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[3].id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(schedule.id, "09:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[5].id, "08:00", "14:00", "12:00", "19:00"),
            generate_schedule_param(shop.schedules[6].id, nil, nil, nil, nil)
          ]

          request.headers['x-client-id'] = generate_token(user_shop_employee)

          put :update, params: {id: shop.id, _json: params}

          expect(response).to have_http_status(:not_found)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Schedule with 'id'=#{schedule.id} [WHERE \"schedules\".\"shop_id\" = $1]").to_h.to_json)
        end

      end
    end
  end
end