class Gallery < ApplicationRecord
  belongs_to :user
  validates :user_id
  has_many :gallery_paintings, dependent: :destroy
  has_many :paintings, through: :gallery_paintings
end
