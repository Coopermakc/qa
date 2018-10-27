module EsHelperAnswer
  def as_indexed_json(params={})
    {
      body: body,
      searching: searching
    }
  end

  def preview
    if description.size > 25
      description[0, 25] + '...'
    else
      description
    end
  end
end
