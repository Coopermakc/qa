class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :answers
  has_many :questions
  has_many :comments, dependent: :destroy

  def author_of?(unit)
    self.id == unit.user_id
  end

  def non_author_of?(unit)
    !author_of?(unit)
  end
end
