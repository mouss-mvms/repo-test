require 'rails_helper'

RSpec.describe Dto::Errors::Unauthorized do

  describe 'to_h' do
    context 'All ok' do
      it 'should return a hash representation of Dto::Errors::Unauthorized' do
        dto = Dto::Errors::Unauthorized.new

        dto_hash = dto.to_h

        expect(dto_hash[:detail]).to eq(dto.detail)
        expect(dto_hash[:message]).to eq(dto.message)
        expect(dto_hash[:status]).to eq(dto.status)
      end
    end
  end

end