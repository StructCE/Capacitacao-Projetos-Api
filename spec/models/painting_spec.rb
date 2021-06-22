require 'rails_helper'

RSpec.describe Painting, type: :model do
  let(:pintor) { create(:painter) }
  let(:estilo) { create(:style) }

  describe 'factory' do
    context 'normal factory' do
      it 'be valid' do
        expect(build(:painting, painter_id: pintor.id, style_id: estilo.id)).to be_valid
      end
    end
  end

  describe 'validations' do
    context '' do

    end
  end
end
