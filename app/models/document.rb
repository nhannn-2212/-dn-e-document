class Document < ApplicationRecord
  # constant
  enum status: {approved: 1, wait: 2, draft: 3, ban: 4, deleted: 5}

  # attr macro
  belongs_to :user
  belongs_to :category
  has_one_attached :doc
  has_many :comments
  has_many :histories
  has_many :favorites
  has_many :fav_users, through: :favorites, source: :user
  accepts_nested_attributes_for :category, reject_if: :reject_category
  delegate :fullname, to: :user, prefix: true, allow_nil: true
  delegate :size, to: :histories, prefix: true
  delegate :content_type, :previewable?, :preview, to: :doc, prefix: false

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
  scope :sort_by_name, ->{order :name}
  scope :search, ->(search){
    left_outer_joins(:category).where("documents.name LIKE ?  OR categories.name LIKE ?", "%#{search}%", "%#{search}%") if search.present?
  }
  scope :find_in_month, ->{where "created_at BETWEEN ? AND ?", DateTime.now.beginning_of_month, DateTime.now.end_of_month}
  scope :find_in_year, ->{where "created_at BETWEEN ? AND ?", DateTime.now.beginning_of_year, DateTime.now.end_of_year}

  def reject_category attr
    attr["name"].blank?
  end
end
