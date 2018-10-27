require 'pry'
class Answer < ApplicationRecord

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include ElasticMyAnalyzer
  include EsHelperAnswer
  include Attachable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  validates :body, :user_id, presence: true

  after_create :send_new_answer
  after_create :subscribers_informer

  settings ES_SETTING do
  mappings dynamic: 'true' do
    indexes :body, type: 'text', analyzer: 'my_analyzer'
    indexes :searching, type: 'boolean'
  end
end

  def best
    ActiveRecord::Base.transaction do
      best_answer = question.best_answer
      if self != best_answer
        best_answer.update!(best: false) if best_answer
        self.update!(best: true)
      end
    end
  end

  def send_new_answer
    AnswerMailer.delay.new_answer(self.question.user)
  end

  def subscribers_informer
    SubscribersSenderJob.perform_later(self)
  end

end
