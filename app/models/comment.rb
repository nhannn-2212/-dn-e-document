class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :document
  belongs_to :comment
  has_many :reply_comments, class_name: Comment.name,
    foreign_key: :reply_comment_id
end
