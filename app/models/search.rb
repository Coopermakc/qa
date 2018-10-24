require 'pry'

class Search
  CONDITIONS = ["Questions", "Answers", "Comments", "Users", "Anywhere"]

  def self.query(query, condition)
    return [] unless CONDITIONS.include?(condition)
    escaped_query = ThinkingSphinx::Query.escape(query)
    if condition == "Anywhere"
      ThinkingSphinx.search escaped_query
    else
      ThinkingSphinx.search escaped_query, classes: [condition.singularize.classify.constantize]
    end
  end
end
