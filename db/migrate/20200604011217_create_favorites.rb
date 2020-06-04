class CreateFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, type: :bigint
      t.references :document, null: false, type: :bigint
      t.timestamps
    end
    add_index :favorites, [:user_id, :document_id]
  end
end
