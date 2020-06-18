class Category < ApplicationRecord
  # attr macro
  belongs_to :user
  belongs_to :category, optional: true, class_name: Category.name, foreign_key: :parent_id
  has_many :categories, class_name: Category.name, foreign_key: :parent_id
  has_many :documents
  delegate :fullname, to: :user, prefix: true, allow_nil: true
  ransack_alias :user, :user_fullname

  validates :name, presence: true,
    length: {minimum: Settings.category_min_length, maximum: Settings.category_max_length},
    uniqueness: true

  def send_create_cate_email
    AdminMailer.create_cate(self).deliver_now
  end

  scope :sort_by_name, ->{order :name}
end
