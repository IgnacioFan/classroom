require 'rails_helper'

RSpec.describe CourseParamsValidator do
  
  describe "#valid?" do
    context "when create a course" do
      subject { 
        CourseParamsValidator.new(course_params)
          .validate_course_required
          .validate_chapters_and_units_presence
          .full_message
      }

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

    context "when update the course" do
      let!(:course) { create(:course)}
      let!(:chapter) { create(:chapter, course: course)}
      let!(:unit) { create(:unit, chapter: chapter)}
      
      subject { 
        CourseParamsValidator.new(course_params)
          .validate_course_required
          .validate_chapters_and_units_missed(course)
          .full_message
      }

      context "with valid params" do
        let(:course_params) {
          {
            name: "Ruby on Rails",
            lecturer: "New Lecturer",
            description: "New Description",
            chapters: [
              {
                id: chapter.id,
                name: "Chapter 1",
                units: [
                  {
                    id: unit.id,
                    name: "Unit 1",
                    description: "Old Description",
                    content: "Old Content",
                    _deleted: true
                  },
                  {
                    name: "Unit 1",
                    description: "New Description",
                    content: "New Content"
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
            id: course.id,  
            name: "Ruby on Rails",
            lecturer: "New Lecturer",
            description: "New Description",
          }
        }
        
        it { is_expected.to eq([false, "Chapter Id (#{chapter.id}) must include\nUnit Id (#{unit.id}) must include"]) }
      end
    end
  end
end
