class CreateDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :documents do |t|
      t.string :name
      t.boolean :status
      t.references :user, null: false, type: :bigint
      t.references :category, null: false,  type: :bigint, foreign_key: true
      t.timestamps
    end
    add_index :documents, [:user_id, :created_at]
  end
end
