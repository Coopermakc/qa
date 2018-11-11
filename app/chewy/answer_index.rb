class AnswerIndex < Chewy::Index

  define_type Answer.includes(:question, :user) do
    field :body
    field :user_id
    field :author, value: ->{user.email}
    field :question_id
    field :question do
      field :title, :body
    end
  end

end
