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
require 'rails_helper'

RSpec.describe Unit, type: :model do
  let(:unit) { build(:unit, name: name, content: content) }

  describe "#validates" do
    let(:name) { "test" }
    let(:content) { "test" }

    subject { unit.save }

    context "with name" do
      it { is_expected.to eq(true) }
    end

    context "without name" do
      let(:name) { "" }
      it { is_expected.to eq(false) }
    end

    context "with content" do
      it { is_expected.to eq(true) }
    end

    context "without content" do
      let(:content) { "" }
      it { is_expected.to eq(false) }
    end
  end
end
