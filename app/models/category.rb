class Category < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :categories, class_name: Category.name, foreign_key: :parent_id

  validates :name, presence: true, length: {
    minimum: Settings.category_min_length,
    maximum: Settings.category_max_length
  }

  scope :sort_by_name, ->{order :name}
end
