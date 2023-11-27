# == Schema Information
#
# Table name: courses
#
#  id          :bigint           not null, primary key
#  description :text
#  lecturer    :string           not null
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:course) { build(:course, name: name, lecturer: lecturer) }

  describe "#validates" do
    let(:name) { "test" }
    let(:lecturer) { "test" }

    subject { course.save }

    context "with name" do
      it { is_expected.to eq(true) }
    end

    context "without name" do
      let(:name) { "" }
      it { is_expected.to eq(false) }
    end

    context "with lecturer" do
      it { is_expected.to eq(true) }
    end

    context "without lecturer" do
      let(:lecturer) { "" }
      it { is_expected.to eq(false) }
    end
  end
end
