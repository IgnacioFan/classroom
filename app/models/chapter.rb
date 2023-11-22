# == Schema Information
#
# Table name: chapters
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  sort_key   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  courses_id :bigint           not null
#
# Indexes
#
#  index_chapters_on_courses_id  (courses_id)
#
# Foreign Keys
#
#  fk_rails_...  (courses_id => courses.id)
#
class Chapter < ApplicationRecord
end
