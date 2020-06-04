class History < ApplicationRecord
  belongs_to :user
  belongs_to :document

  scope :find_in_month, ->{where "created_at >= ? AND created_at <= ?", DateTime.now.beginning_of_month, DateTime.now.end_of_month}
end
