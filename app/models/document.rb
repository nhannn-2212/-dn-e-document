class Document < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_one_attached :doc

  enum status: {approved: 1, wait: 2, draft: 3, reject: 4}
end
