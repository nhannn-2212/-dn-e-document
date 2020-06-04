class Category < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :categories, class_name: Category.name, foreign_key: :parent_id
end
