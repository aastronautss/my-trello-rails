class AddTokenToCards < ActiveRecord::Migration
  def change
    add_column :cards, :token, :string
    add_index :cards, :token

    Card.all.each do |card|
      card.token = SecureRandom.urlsafe_base64
      card.save
    end
  end
end
