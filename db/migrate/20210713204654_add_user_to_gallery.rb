class AddUserToGallery < ActiveRecord::Migration[6.0]
  def change
    add_reference :galleries, :user, null: false, foreign_key: true
  end
end
