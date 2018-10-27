module ApplicationHelper
  def search_result_link(result)
    case result[:record_type]
    when 'Question'
      question_path(result[:record_id])
    when 'Answer'
      answer_path(result[:record_id])
    end
  end
end
