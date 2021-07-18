class PainterSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :bio, :born, :died, :painter_url

  has_many :paintings

  def painter_url
    return nil unless object.photo.attached?

    rails_blob_url(object.photo)
  end
end
