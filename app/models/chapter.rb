# == Schema Information
#
# Table name: chapters
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  sort_key   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :bigint           not null
#
# Indexes
#
#  index_chapters_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
class Chapter < ApplicationRecord
  belongs_to :course

  has_many :units, dependent: :destroy

  validates :name, presence: true
end
