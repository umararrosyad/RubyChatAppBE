class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :users do |t|
      t.primary_key :id 
      t.string :nickname, null: false
      t.timestamps
    end
  end
end
