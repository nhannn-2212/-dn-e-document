class CreateHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :histories do |t|
      t.references :user, null: false, type: :bigint
      t.references :document, null: false, type: :bigint
      t.timestamps
    end
    add_index :histories, [:user_id, :document_id, :created_at]
  end
end
