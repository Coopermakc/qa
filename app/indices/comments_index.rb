ThinkingSphinx::Index.define :comment, with: :active_record do
  #indexes
  indexes comment_body
  indexes user.email

  #attributes

end
