class GallerySerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :photo_url

  has_many :paintings

  def photo_url
    return nil unless object.photo.attached?

    rails_blob_url(object.photo)
  end
end
