require 'rails_helper'

RSpec.describe Painter, type: :model do
  describe 'factory' do 
    context 'when normal factory' do 
      it 'be valid' do 
        artista = build(:painter)
        expect(artista).to be_valid
      end
    end
  end

  describe 'validations' do 
    context 'when the painter does not have a name' do 
      it { expect(build(:painter, name: nil)).to be_invalid }
    end

    context 'when the painter does not have a bio' do 
      it { expect(build(:painter, bio: nil)).to be_invalid }
    end

    context 'when the painter does not have a born date' do 
      it { expect(build(:painter, born: nil)).to be_invalid }
    end

    context 'when the painter does not have a death date' do 
      it { expect(build(:painter, died: nil)).to be_invalid }
    end

    context "when the painter's name has less than 3 characters" do 
      it { expect(build(:painter, name: 'oi')).to be_invalid }
    end

    context "when the painter's bio has less than 30 characters" do 
      it { expect(build(:painter, bio: '12345678912345678912345678912')).to be_invalid }
    end

    context "when the painter's born date has less than 10 characters" do 
      it { expect(build(:painter, born: '2020-01-0')).to be_invalid }
    end

    context "when the painter's death date has less than 10 characters" do 
      it { expect(build(:painter, died: '2020-01-0')).to be_invalid }
    end

    context "when the painter's birth date is not valid" do 
      it { expect(build(:painter, died: '2020-01-01', born: '2021-01-01')).to be_invalid }
    end
  end
end
