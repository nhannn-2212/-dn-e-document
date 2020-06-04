class Document < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_one_attached :doc
end
