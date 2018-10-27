class Question < ApplicationRecord

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include ElasticMyAnalyzer
  include EsHelper
  include Votable
  include Attachable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  has_many :attachments, as: :attachable

  validates :body, :title, presence: true

  after_create :author_subscribe

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  settings ES_SETTING do
  mappings dynamic: 'true' do
    indexes :title, type: 'text', analyzer: 'my_analyzer'
    indexes :body, type: 'text', analyzer: 'my_analyzer'
    indexes :searching, type: 'boolean'
  end
end

  def best_answer
    answers.where(best: true).first
  end
  private

  def author_subscribe
    subscriptions.create!(user: user)
  end
end
