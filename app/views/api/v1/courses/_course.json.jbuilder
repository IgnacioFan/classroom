json.(course, :id, :name, :lecturer, :description)
json.chapters course.chapters.sort_by{ |chapter| chapter.sort_key } do |chapter|
  json.(chapter, :id, :name)
  json.units chapter.units.sort_by{ |unit| unit.sort_key } do |unit|
    json.(unit, :id, :name, :description, :content)
  end
end
