json.courses @courses.each do |course|
  json.partial! "course", course: course
end
