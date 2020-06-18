class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  # constant
  enum role: {member: 1, admin: 2}

  # attr macro
  attr_accessor :activation_token

  # relation
  has_many :documents, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :histories, dependent: :destroy
  has_many :fav_docs, through: :favorites, source: :document
  has_many :categories

  # validates
  validates :fullname, presence: true,
    length: {maximum: Settings.name_max_length}

  # callback macro
  before_save ->{email.downcase!}
  before_create :create_activation_digest

  # scope
  scope :sort_by_name, ->{order :fullname}
  scope :find_in_month, ->{where "created_at BETWEEN ? AND ?", DateTime.now.beginning_of_month, DateTime.now.end_of_month}

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

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return unless digest

    BCrypt::Password.new(digest).is_password?(token)
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def activate
    update_attributes active: true, coin: 0, activation_digest: nil
  end

  class << self
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
