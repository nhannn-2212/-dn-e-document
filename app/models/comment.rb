class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :document
  belongs_to :comment, optional: true, class_name: Comment.name,
    foreign_key: :reply_comment_id
  has_many :reply_comments, class_name: Comment.name,
    foreign_key: :reply_comment_id

  scope :by_created_at, ->{order created_at: :desc}
  scope :root_comment, ->{where reply_comment_id: nil}
end
