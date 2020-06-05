class Document < ApplicationRecord
  # constant
  enum status: {approved: 1, wait: 2, draft: 3, ban: 4}

  # attr macro
  belongs_to :user
  belongs_to :category
  has_one_attached :doc

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
end
