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
    context 'painter presence' do
      it { expect(build(:painting, painter_id: nil, style_id: estilo.id)).to be_invalid }
    end

    context 'style presence' do
      it { expect(build(:painting, painter_id: pintor.id, style_id: nil)).to be_invalid }
    end

    context 'name presence' do
      it { expect(build(:painting, painter_id:  pintor.id, style_id: estilo.id, name: nil)).to be_invalid }
    end

    context 'time of completion presence' do
      it { expect(build(:painting, painter_id:  pintor.id, style_id: estilo.id, time_of_completion: nil)).to be_invalid }
    end
  end
end
