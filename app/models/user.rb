class User < ApplicationRecord
  has_many :documents, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :histories, dependent: :destroy

  enum role: {member: 1, admin: 2}
end
