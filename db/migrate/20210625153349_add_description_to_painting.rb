class AddDescriptionToPainting < ActiveRecord::Migration[6.0]
  def change
    add_column :paintings, :description, :text
  end
end
