class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :email, :authentication_token, :user_photo, :is_admin

  def user_photo
    return nil unless object.photo.attached?

    rails_blob_path(object.photo, only_path: true)
  end
end
