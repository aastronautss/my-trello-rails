class AddTokenToLists < ActiveRecord::Migration
  def change
    add_column :lists, :token, :string
    add_index :lists, :token

    List.all.each do |list|
      list.token = SecureRandom.urlsafe_base64
      list.save
    end
  end
end
