class History < ApplicationRecord
  belongs_to :user
  belongs_to :document

  scope :find_in_month, ->{where "created_at BETWEEN ? AND ?", DateTime.now.beginning_of_month, DateTime.now.end_of_month}
  scope :find_in_year, ->{where "created_at BETWEEN ? AND ?", DateTime.now.beginning_of_year, DateTime.now.end_of_year}
end
