module EsHelperAnswer
  def as_indexed_json(params={})
    {
      body: body,
      searching: searching
    }
  end

  def preview
    if body.size > 25
      body[0, 25] + '...'
    else
      body
    end
  end
end
