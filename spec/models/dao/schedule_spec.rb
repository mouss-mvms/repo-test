require 'rails_helper'

RSpec.describe Dao::Schedule, type: :model do

  describe 'update' do
    context 'Open all day long with close during lunch' do
      context 'All ok' do
        it 'should return updated schedule' do
          schedule = create(:schedule, am_open: "10:00", am_close: "12:30", pm_open: "14:00", pm_close: "18:00")
          dto = Dto::Schedule::Request.new({
                                             id: schedule.id,
                                             open_morning: "09:00",
                                             close_morning: "12:45",
                                             open_afternoon: "14:30",
                                             close_afternoon: "19:00",
                                           })

          schedule = Dao::Schedule.update(dto.to_h)

          expect(schedule).to be_instance_of(::Schedule)
          expect(schedule.id).to eq(dto.id)
          expect(schedule.am_open&.strftime("%H:%M")).to eq(dto.open_morning)
          expect(schedule.am_close&.strftime("%H:%M")).to eq(dto.close_morning)
          expect(schedule.pm_open&.strftime("%H:%M")).to eq(dto.open_afternoon)
          expect(schedule.pm_close&.strftime("%H:%M")).to eq(dto.close_afternoon)
        end
      end

      context 'Params Incorrect' do
        context 'Open Morning is missing' do
          it 'should return nil' do
            schedule = create(:schedule, am_open: "10:00", am_close: "12:30", pm_open: "14:00", pm_close: "18:00")
            dto = Dto::Schedule::Request.new({
                                               id: schedule.id,
                                               open_morning: nil,
                                               close_morning: "12:45",
                                               open_afternoon: "14:30",
                                               close_afternoon: "19:00",
                                             })

            schedule = Dao::Schedule.update(dto.to_h)

            expect(schedule).to be_nil
          end
        end

        context 'Close Morning is missing' do
          it 'should return nil' do
            schedule = create(:schedule, am_open: "10:00", am_close: "12:30", pm_open: "14:00", pm_close: "18:00")
            dto = Dto::Schedule::Request.new({
                                               id: schedule.id,
                                               open_morning: "09:00",
                                               close_morning: nil,
                                               open_afternoon: "14:30",
                                               close_afternoon: "19:00",
                                             })

            schedule = Dao::Schedule.update(dto.to_h)

            expect(schedule).to be_nil
          end
        end

        context 'Open afternoon is missing' do
          it 'should return nil' do
            schedule = create(:schedule, am_open: "10:00", am_close: "12:30", pm_open: "14:00", pm_close: "18:00")
            dto = Dto::Schedule::Request.new({
                                               id: schedule.id,
                                               open_morning: "09:00",
                                               close_morning: "12:45",
                                               open_afternoon: nil,
                                               close_afternoon: "19:00",
                                             })

            schedule = Dao::Schedule.update(dto.to_h)

            expect(schedule).to be_nil
          end
        end

        context 'Close afternoon is missing' do
          it 'should return nil' do
            schedule = create(:schedule, am_open: "10:00", am_close: "12:30", pm_open: "14:00", pm_close: "18:00")
            dto = Dto::Schedule::Request.new({
                                               id: schedule.id,
                                               open_morning: "09:00",
                                               close_morning: "12:45",
                                               open_afternoon: "14:30",
                                               close_afternoon: nil,
                                             })

            schedule = Dao::Schedule.update(dto.to_h)

            expect(schedule).to be_nil
          end
        end
      end
    end

    context 'Open all day long' do
      context 'All ok' do
        it 'should return updated schedule' do
          schedule = create(:schedule, am_open: "10:00", am_close: "12:30", pm_open: "14:00", pm_close: "18:00")
          dto = Dto::Schedule::Request.new({
                                             id: schedule.id,
                                             open_morning: "09:00",
                                             close_morning: nil,
                                             open_afternoon: nil,
                                             close_afternoon: "19:00",
                                           })

          schedule = Dao::Schedule.update(dto.to_h)

          expect(schedule).to be_instance_of(::Schedule)
          expect(schedule.id).to eq(dto.id)
          expect(schedule.am_open&.strftime("%H:%M")).to eq(dto.open_morning)
          expect(schedule.am_close&.strftime("%H:%M")).to eq(dto.close_morning)
          expect(schedule.pm_open&.strftime("%H:%M")).to eq(dto.open_afternoon)
          expect(schedule.pm_close&.strftime("%H:%M")).to eq(dto.close_afternoon)
        end
      end

      context 'Params missing' do
        context 'Open morning is missing' do
          it 'should return nil' do
            schedule = create(:schedule, am_open: "10:00", am_close: "12:30", pm_open: "14:00", pm_close: "18:00")
            dto = Dto::Schedule::Request.new({
                                               id: schedule.id,
                                               open_morning: nil,
                                               close_morning: nil,
                                               open_afternoon: nil,
                                               close_afternoon: "19:00",
                                             })

            schedule = Dao::Schedule.update(dto.to_h)

            expect(schedule).to be_nil
          end
        end

        context 'Close morning is missing' do
          it 'should return nil' do
            schedule = create(:schedule, am_open: "10:00", am_close: "12:30", pm_open: "14:00", pm_close: "18:00")
            dto = Dto::Schedule::Request.new({
                                               id: schedule.id,
                                               open_morning: "09:00",
                                               close_morning: nil,
                                               open_afternoon: nil,
                                               close_afternoon: nil,
                                             })

            schedule = Dao::Schedule.update(dto.to_h)

            expect(schedule).to be_nil
          end
        end
      end
    end

    context 'Open morning only' do
      context 'All ok' do
        it 'should return updated schedule' do
          schedule = create(:schedule, am_open: "10:00", am_close: "12:30", pm_open: "14:00", pm_close: "18:00")
          dto = Dto::Schedule::Request.new({
                                             id: schedule.id,
                                             open_morning: "09:00",
                                             close_morning: "12:45",
                                             open_afternoon: nil,
                                             close_afternoon: nil,
                                           })

          schedule = Dao::Schedule.update(dto.to_h)

          expect(schedule).to be_instance_of(::Schedule)
          expect(schedule.id).to eq(dto.id)
          expect(schedule.am_open&.strftime("%H:%M")).to eq(dto.open_morning)
          expect(schedule.am_close&.strftime("%H:%M")).to eq(dto.close_morning)
          expect(schedule.pm_open&.strftime("%H:%M")).to eq(dto.open_afternoon)
          expect(schedule.pm_close&.strftime("%H:%M")).to eq(dto.close_afternoon)
        end
      end

      context 'Params Incorrect' do
        context 'Open Morning is missing' do
          it 'should return nil' do
            schedule = create(:schedule, am_open: "10:00", am_close: "12:30", pm_open: "14:00", pm_close: "18:00")
            dto = Dto::Schedule::Request.new({
                                               id: schedule.id,
                                               open_morning: nil,
                                               close_morning: "12:45",
                                               open_afternoon: nil,
                                               close_afternoon: nil,
                                             })

            schedule = Dao::Schedule.update(dto.to_h)

            expect(schedule).to be_nil
          end
        end

        context 'Close Morning is missing' do
          it 'should return nil' do
            schedule = create(:schedule, am_open: "10:00", am_close: "12:30", pm_open: "14:00", pm_close: "18:00")
            dto = Dto::Schedule::Request.new({
                                               id: schedule.id,
                                               open_morning: "09:00",
                                               close_morning: nil,
                                               open_afternoon: nil,
                                               close_afternoon: nil,
                                             })

            schedule = Dao::Schedule.update(dto.to_h)

            expect(schedule).to be_nil
          end
        end
      end
    end

    context 'Open afternoon only' do
      context 'All ok' do
        it 'should return updated schedule' do
          schedule = create(:schedule, am_open: "10:00", am_close: "12:30", pm_open: "14:00", pm_close: "18:00")
          dto = Dto::Schedule::Request.new({
                                             id: schedule.id,
                                             open_morning: nil,
                                             close_morning: nil,
                                             open_afternoon: "14:30",
                                             close_afternoon: "19:00",
                                           })

          schedule = Dao::Schedule.update(dto.to_h)

          expect(schedule).to be_instance_of(::Schedule)
          expect(schedule.id).to eq(dto.id)
          expect(schedule.am_open&.strftime("%H:%M")).to eq(dto.open_morning)
          expect(schedule.am_close&.strftime("%H:%M")).to eq(dto.close_morning)
          expect(schedule.pm_open&.strftime("%H:%M")).to eq(dto.open_afternoon)
          expect(schedule.pm_close&.strftime("%H:%M")).to eq(dto.close_afternoon)
        end
      end

      context 'Params Incorrect' do
        context 'Open afternoon is missing' do
          it 'should return nil' do
            schedule = create(:schedule, am_open: "10:00", am_close: "12:30", pm_open: "14:00", pm_close: "18:00")
            dto = Dto::Schedule::Request.new({
                                               id: schedule.id,
                                               open_morning: nil,
                                               close_morning: nil,
                                               open_afternoon: nil,
                                               close_afternoon: "19:00",
                                             })

            schedule = Dao::Schedule.update(dto.to_h)

            expect(schedule).to be_nil
          end
        end

        context 'Close afternoon is missing' do
          it 'should return nil' do
            schedule = create(:schedule, am_open: "10:00", am_close: "12:30", pm_open: "14:00", pm_close: "18:00")
            dto = Dto::Schedule::Request.new({
                                               id: schedule.id,
                                               open_morning: nil,
                                               close_morning: nil,
                                               open_afternoon: "14:30",
                                               close_afternoon: nil,
                                             })

            schedule = Dao::Schedule.update(dto.to_h)

            expect(schedule).to be_nil

          end
        end
      end
    end
  end

end