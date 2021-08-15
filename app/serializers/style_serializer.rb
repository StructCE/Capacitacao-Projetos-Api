class StyleSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :description, :image_url, :type

  has_many :paintings

  def image_url
    return nil unless object.photo.attached?

    rails_blob_url(object.photo)
  end

  def type
    'style'
  end
end
