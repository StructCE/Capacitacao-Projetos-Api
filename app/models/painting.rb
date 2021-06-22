class Painting < ApplicationRecord
  belongs_to :painter
  belongs_to :style
  has_one_attached :painting
  validates :painter_id, :style_id, presence: true
end
