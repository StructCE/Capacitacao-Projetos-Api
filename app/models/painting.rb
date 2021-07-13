class Painting < ApplicationRecord
  belongs_to :painter, dependent: :destroy
  belongs_to :style, dependent: :destroy
  has_one_attached :painting
  validates :painter_id, :style_id, :time_of_completion, :name, presence: true
end
