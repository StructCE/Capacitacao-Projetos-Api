require 'rails_helper'

RSpec.describe Gallery, type: :model do
  let(:pintor) { create(:painter) }
  let(:estilo) { create(:style) }
  let(:usuario) { create(:user) }
  let(:pintura) { create(:painting, painter_id: pintor.id, style_id: estilo.id) }
  
  describe 'factory' do
    context 'normal factory' do
      it 'be valid' do
        expect(build(:gallery, user_id: usuario.id)).to be_valid
      end
    end
  end

  describe 'validations' do 
    context 'without user' do 
      it { expect(build(:gallery)).to be_invalid}
    end

    context 'add painting to gallery' do 
      it { expect(build(:gallery, user_id: usuario.id, painting_ids: pintura.id)).to be_valid}
    end
  end
end
