json.(course, :id, :name, :lecturer, :description)
json.chapters course.chapters do |chapter|
  json.(chapter, :id, :name, :sort_key)
  json.units chapter.units do |unit|
    json.(unit, :id, :name, :description, :content, :sort_key)
  end
end
