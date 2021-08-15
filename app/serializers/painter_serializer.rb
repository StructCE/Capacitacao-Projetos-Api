class PainterSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :bio, :born, :died, :image_url, :type

  has_many :paintings

  def image_url
    return nil unless object.photo.attached?

    rails_blob_url(object.photo, only_path: true)
  end

  def type
    'painter'
  end
end
