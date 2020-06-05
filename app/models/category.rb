class Category < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :categories, class_name: Category.name, foreign_key: :parent_id

  scope :by_name, ->{order :name}
end
