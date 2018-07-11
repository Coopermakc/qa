class AnswersChannel < ApplicationCableCabel::Channel
  def follow
    stream_from "answers"
  end
end
