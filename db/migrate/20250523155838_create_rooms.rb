class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.primary_key :id 
      t.string :name

      t.timestamps
    end
  end
end
