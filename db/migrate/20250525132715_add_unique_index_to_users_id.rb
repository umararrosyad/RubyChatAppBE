class AddUniqueIndexToUsersId < ActiveRecord::Migration[8.0] # atau 8.0 jika kamu pakai Rails 8
  def change
    # Hapus index lama jika ada
    remove_index :users, :id if index_exists?(:users, :id)

    # Tambahkan index unik
    add_index :users, :id, unique: true
  end
end