class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :reply_comment, null: true, index: true
      t.references :user, null: false, type: :bigint
      t.references :document, null: false,  type: :bigint
      t.timestamps
    end
  end
end
