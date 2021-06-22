class AddFieldsToPainting < ActiveRecord::Migration[6.0]
  def change
    add_column :paintings, :name, :string
    add_column :paintings, :time_of_completion, :date
  end
end
