# == Schema Information
#
# Table name: units
#
#  id          :bigint           not null, primary key
#  content     :text             not null
#  description :string
#  name        :string           not null
#  sort_key    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  chapter_id  :bigint           not null
#
# Indexes
#
#  index_units_on_chapter_id  (chapter_id)
#
# Foreign Keys
#
#  fk_rails_...  (chapter_id => chapters.id)
#
class Unit < ApplicationRecord
  belongs_to :chapter

  validates :name, presence: true
  validates :content, presence: true
end
