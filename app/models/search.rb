require 'pry'

class Search

  MODELS_TO_SEARCH = [Question, Answer].freeze

  def initialize
    @raw_data = nil
    @results = nil
  end

  def search(search_word, page = nil, per_page = nil)
    page ||= 1
    per_page ||= 10
    save_data run_elastic(search_word, page, per_page)
    self
  end

  def raw_data
    @raw_data
  end

  def results
    @results
  end

  def get_question_for_answer_show(result)
    @question = Answer.find(result[:record_id]).question
  end

  private

  def run_elastic(search_word, page, per_page)
    Elasticsearch::Model
      .search(search_query(search_word), MODELS_TO_SEARCH)
      .paginate(page: page, per_page: per_page)
  end

  def save_data(data)
    @raw_data = data
    @results = create_answers(data)
  end

  def create_answers(data)
    data.records.map do |result|
      {
        hint: build_hint(result),
        record_type: result.class.name,
        record_id: result.id
      }
    end
  end

  def search_query(query)
    {
      query: {
        bool: {
          must: {
            multi_match: {
              query: query,
              fields: %w(title body),
              operator: 'and'
            }
          },
          filter: [
            {
              term: { searching: false }
            }
          ]
        }
      }
    }
  end

  def build_hint(record)
    {
      body: record.body,
      preview: record.preview,
      type: hint_type(record)
    }
  end

  def hint_type(record)
    case record.class.to_s
    when 'Question' then 'Вопрос'
    when 'Answer' then 'Ответ'
    end
  end
end
