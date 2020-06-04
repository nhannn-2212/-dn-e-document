class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.references :parent, null: true, index: true
      t.references :user, null: false, type: :bigint
      t.timestamps
    end
    add_index :categories, [:user_id, :created_at]
  end
end
