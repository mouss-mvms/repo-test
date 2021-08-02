require 'rails_helper'

RSpec.describe Dto::Schedule::Response do
  describe 'create' do
    context 'All ok' do
      it 'should return a Dto::Schedule::Response' do
        schedule = create(:schedule)
        result = Dto::Schedule::Response.create(schedule)

        expect(result).to be_instance_of(Dto::Schedule::Response)
        expect(result.id).to eq(schedule.id)
        expect(result.day).to eq(Dto::Schedule::Response.int_to_day(schedule.day))
        expect(result.open_afternoon).to eq(schedule.pm_open&.strftime("%H:%M"))
        expect(result.open_morning).to eq(schedule.am_open&.strftime("%H:%M"))
        expect(result.close_morning).to eq(schedule.am_close&.strftime("%H:%M"))
        expect(result.close_afternoon).to eq(schedule.pm_close&.strftime("%H:%M"))
      end
    end
  end

  describe 'int_to_day' do
    context 'Int is 1' do
      it 'should return Lundi' do
        expect(Dto::Schedule::Response.int_to_day(1)).to eq('Lundi')
      end
    end

    context 'Int is 2' do
      it 'should return Mardi' do
        expect(Dto::Schedule::Response.int_to_day(2)).to eq('Mardi')
      end
    end

    context 'Int is 3' do
      it 'should return Mercredi' do
        expect(Dto::Schedule::Response.int_to_day(3)).to eq('Mercredi')
      end
    end

    context 'Int is 4' do
      it 'should return Jeudi' do
        expect(Dto::Schedule::Response.int_to_day(4)).to eq('Jeudi')
      end
    end

    context 'Int is 5' do
      it 'should return Vendredi' do
        expect(Dto::Schedule::Response.int_to_day(5)).to eq('Vendredi')
      end
    end

    context 'Int is 6' do
      it 'should return Samedi' do
        expect(Dto::Schedule::Response.int_to_day(6)).to eq('Samedi')
      end
    end

    context 'Int is 7' do
      it 'should return Dimanche' do
        expect(Dto::Schedule::Response.int_to_day(7)).to eq('Dimanche')
      end
    end

    context 'Int is not correct' do
      it 'should return nil' do
        expect(Dto::Schedule::Response.int_to_day(89)).to be_nil
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should return a hash representation of Dto::Schedule::Response' do
        dto = Dto::Schedule::Response.create(create(:schedule))

        dto_hash = dto.to_h

        expect(dto_hash).to be_instance_of(Hash)
        expect(dto_hash[:id]).to eq(dto.id)
        expect(dto_hash[:day]).to eq(dto.day)
        expect(dto_hash[:openMorning]).to eq(dto.open_morning)
        expect(dto_hash[:openAfternoon]).to eq(dto.open_afternoon)
        expect(dto_hash[:closeAfternoon]).to eq(dto.close_afternoon)
        expect(dto_hash[:closeMorning]).to eq(dto.close_morning)
      end
    end
  end
end