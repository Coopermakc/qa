class StoreIndex < Chewy::Index
  define_type Question.includes(:user,) do
    field :title, :body
    field :user_id
    field :author, value: -> {user.email}
  end

  define_type Answer.includes(:question, :user) do
    field :body
    field :user_id
    field :author, value: ->{user.email}
    field :question do
      field :title, :body
    end
  end

  # define_type Comments.includes(:question, :answer, :user) do
  #   field :comment_body
  # end
  #
  # define_type User.include(:question, :answer, :comment) do
  #   field :email
  #   field :question do
  #     field :title, :body
  #   end
  #   field :answer do
  #     field :body
  #   end
  #   field :comment do
  #     field :comment
  #   end
  # end
end
