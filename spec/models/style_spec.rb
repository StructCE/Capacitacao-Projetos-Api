require 'rails_helper'

RSpec.describe Style, type: :model do
  describe 'factory' do 
    context 'when normal factory' do 
      it 'be valid' do 
        artista = build(:style)
        expect(artista).to be_valid
      end
    end
  end

  describe 'validations' do 
    context 'when the style does not have a name' do 
      it { expect(build(:style, name: nil)).to be_invalid }
    end

    context 'when the style does not have a description' do 
      it { expect(build(:style, description: nil)).to be_invalid }
    end

    context "when the style's name has less than 3 characters" do 
      it { expect(build(:style, name: 'oi')).to be_invalid }
    end

    context "when the style's description has less than 30 characters" do 
      it { expect(build(:style, description: '12345678912345678912345678912')).to be_invalid }
    end
  end
end
