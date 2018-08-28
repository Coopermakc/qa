class AttachmentSerializer < ActiveModel::Serializer
  #attributes :id, :file, :created_at, :updated_at
  attributes :url

  def url
    object.file.url
  end
end
