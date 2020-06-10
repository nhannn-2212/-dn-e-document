class Document < ApplicationRecord
  # constant
  enum status: {approved: 1, deleted: 2, wait: 3, ban: 4}

  # attr macro
  belongs_to :user
  belongs_to :category, optional: true
  has_one_attached :doc
  has_many :comments

  # validates
  validates :name, presence: true, length: {
    minimum: Settings.doc_min_length,
    maximum: Settings.doc_max_length
  }
  validates :doc, presence: true, content_type: {
    in: Settings.doc_type,
    message: I18n.t("error.invalid.doc_format")
  },
  size: {
    less_than: Settings.doc_size.megabytes,
    message:
      I18n.t("error.invalid.doc_size", size: Settings.doc_size.megabytes)
  }

  # scope
  scope :sort_by_created_at, ->{order created_at: :desc}
  scope :sort_by_name, ->{order name: :asc}
  scope :search, ->(search){
    left_outer_joins(:category).where("documents.name LIKE ?  OR categories.name LIKE ?", "%#{search}%", "%#{search}%") if search.present?
  }
  scope :find_in_month, ->{where "created_at >= ? AND created_at <= ?", DateTime.now.beginning_of_month, DateTime.now.end_of_month}
end
