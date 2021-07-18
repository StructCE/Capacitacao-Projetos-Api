class Painting < ApplicationRecord
  belongs_to :painter, dependent: :destroy
  belongs_to :style, dependent: :destroy
  has_one_attached :painting
  validates :painter_id, :style_id, :time_of_completion, :name, presence: true
  has_many :gallery_paintings, dependent: :destroy
  has_many :galleries, through: :gallery_paintings
end
