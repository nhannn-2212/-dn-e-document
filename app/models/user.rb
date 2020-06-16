class User < ApplicationRecord
  # constant
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  enum role: {member: 1, admin: 2}

  # relation
  has_many :documents, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :histories, dependent: :destroy
  has_many :fav_docs, through: :favorites, source: :document
  has_many :categories

  # validates
  validates :email, presence: true,
    length: {maximum: Settings.email_max_length},
    uniqueness: {case_sensitive: false},
    format: {with: VALID_EMAIL_REGEX}
  validates :fullname, presence: true,
    length: {maximum: Settings.name_max_length}
  validates :password, presence: true,
    length: {minimum: Settings.pass_min_length}, allow_nil: true

  # callback macro
  before_save ->{email.downcase!}
  has_secure_password

  # scope
  scope :sort_by_name, ->{order :fullname}

  def minus_coin mcoin
    update_attribute :coin, coin - mcoin
  end

  def add_coin mcoin
    update_attribute :coin, coin + mcoin
  end

  def create_history doc_id
    history = histories.new(document_id: doc_id)
    return if history.save

    flash[:danger] = error.create_history
    redirect_to root_url
  end

  def block_user
    update_attribute! :active, false
  end

  def send_block_email
    UserMailer.block_user(self).deliver_now
  end

  def send_upload_email doc
    UserMailer.upload_doc(self, doc).deliver_now
  end

  def favorite doc
    fav_docs << doc
  end

  def unfavorite doc
    fav_docs.delete doc
  end
end
