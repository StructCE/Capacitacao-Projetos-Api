class PaintingSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :time_of_completion, :description, :image_url, :type

  belongs_to :style
  belongs_to :painter

  def image_url
    return nil unless object.painting.attached?

    rails_blob_url(object.painting, only_path: true)
  end

  def type
    'painting'
  end
end
