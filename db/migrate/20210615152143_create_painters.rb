class CreatePainters < ActiveRecord::Migration[6.0]
  def change
    create_table :painters do |t|
      t.string :name
      t.text :bio
      t.date :born
      t.date :died

      t.timestamps
    end
  end
end
