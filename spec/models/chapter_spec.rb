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
require 'rails_helper'

RSpec.describe Chapter, type: :model do
  let(:chapter) { build(:chapter, name: name) }

  describe "#validates" do
    subject { chapter.save }

    context "with name" do
      let(:name) { "test" }
      it { is_expected.to eq(true) }
    end

    context "without name" do
      let(:name) { "" }
      it { is_expected.to eq(false) }
    end
  end
end
