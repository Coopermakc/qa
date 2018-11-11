class QuestionIndex < Chewy::Index
  define_type Question.includes(:user) do
    field :title, :body
    field :user_id
    field :author, value: -> {user.email}
  end

end
