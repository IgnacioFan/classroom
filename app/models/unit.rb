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
#  chapters_id :bigint           not null
#
# Indexes
#
#  index_units_on_chapters_id  (chapters_id)
#
# Foreign Keys
#
#  fk_rails_...  (chapters_id => chapters.id)
#
class Unit < ApplicationRecord
end
