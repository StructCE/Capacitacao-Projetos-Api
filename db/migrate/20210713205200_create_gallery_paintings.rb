class CreateGalleryPaintings < ActiveRecord::Migration[6.0]
  def change
    create_table :gallery_paintings do |t|
      t.references :gallery, null: false, foreign_key: true
      t.references :painting, null: false, foreign_key: true

      t.timestamps
    end
  end
end
