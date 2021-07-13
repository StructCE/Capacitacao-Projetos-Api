class PaintingSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :time_of_completion, :description, :painting_url
  belongs_to :style
  belongs_to :painter

  def painting_url
    return nil unless object.painting.attached?

    rails_blob_url(object.painting)
  end
end
