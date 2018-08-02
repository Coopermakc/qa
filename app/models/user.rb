class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:github]
  has_many :answers
  has_many :questions
  has_many :comments, dependent: :destroy
  has_many :authorizations

  def author_of?(unit)
    self.id == unit.user_id
  end

  def non_author_of?(unit)
    !author_of?(unit)
  end

  def self.from_omniauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    if auth.info[:email]
      #binding.pry
      email = auth.info[:email]
      user = User.where(email: email).first
      if user
        user.create_authorization(auth)
      else
        password = Devise.friendly_token[0,10]
        user = User.create!(email: email, password: password, password_confirmation: password)
        user.create_authorization(auth)
      end
    else
      user = User.new
    end
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
