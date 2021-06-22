class Style < ApplicationRecord
  validates :name, :description, presence: :true
  validates_length_of :name, minimum: 3
  validates_length_of :description, minimum: 30
  has_many :paintings
end
