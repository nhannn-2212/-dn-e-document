class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :fullname
      t.integer :role, default: 1
      t.string :password_digest
      t.boolean :active
      t.integer :coin
      t.timestamps
    end
  end
end