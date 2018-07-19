class QuestionsChannel < ApplicationCable::Channel
  def follow
    stream_from "comments"
  end
end
