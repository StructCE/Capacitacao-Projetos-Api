class GallerySerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :image_url

  has_many :paintings

  def image_url
    return nil unless object.photo.attached?

    rails_blob_path(object.photo, only_path: true)
  end
end
