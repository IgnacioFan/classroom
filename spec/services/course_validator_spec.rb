require 'rails_helper'

RSpec.describe CourseParamsValidator do
  
  describe "#valid?" do
    context "when create" do
      subject { CourseParamsValidator.new(course_params, "create").valid? }

      context "with valid params" do
        let(:course_params) {
          {
            name: "Ruby on Rails",
            lecturer: "New Lecturer",
            description: "New Description",
            chapters: [
              {
                name: "Chapter 1",
                units: [
                  {
                    name: "Unit 1",
                    description: "Description 1",
                    content: "Content 1"
                  },
                  {
                    name: "Unit 2",
                    description: "Description 2",
                    content: "Content 2"
                  }
                ]
              }
            ]
          }
        }
        
        it { is_expected.to eq([true, ""]) }
      end

      context "with invalid params" do
        let(:course_params) {
          {
            name: "Ruby on Rails",
            lecturer: "",
            description: "New Description",
            chapters: [
              {
                name: "Chapter 1",
                units: [
                  {
                    name: "Unit 1",
                    description: "Description 1",
                    content: ""
                  },
                  {
                    name: "",
                    description: "Description 2",
                    content: "Content 2"
                  }
                ]
              }
            ]
          }
        }
        it { is_expected.to eq([false, "Name and lecture cannot be blank\nEach unit must have name and content"]) }
      end
    end

    context "when update" do
      subject { CourseParamsValidator.new(course_params, "update").valid? }

      context "without units" do
        let(:course_params) {
          {
            name: "Ruby on Rails",
            lecturer: "New Lecturer",
            description: "New Description",
            chapters: [
              {
                name: "Chapter 1"
              }
            ]
          }
        }
        
        it { is_expected.to eq([true, ""]) }
      end

      context "without chapters" do
        let(:course_params) {
          {
            name: "Ruby on Rails",
            lecturer: "New Lecturer",
            description: "New Description",
          }
        }
        
        it { is_expected.to eq([true, ""]) }
      end
    end
  end
end
