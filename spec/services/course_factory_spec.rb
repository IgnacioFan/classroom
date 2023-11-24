require "rails_helper"

RSpec.describe CourseFactory do
  let(:course_params) {
    {
      name: "Ruby on Rails",
      lecturer: "test",
      description: "test",
      chapters: [
        {
          name: "Chapter A",
          sort_key: 0,
          units: [
            {
              name: "Unit 1",
              description: "",
              content: "Hello World",
              sort_key: 0
            }
          ]
        },
        {
          name: "Chapter B",
          sort_key: 1,
          units: [
            {
              name: "Unit 1",
              description: "",
              content: "Hello World",
              sort_key: 0
            }
          ]
        }
      ]
    }
  }

  describe "#build" do
    context "when course has all required attributes" do 
      it "return course" do
        factory = CourseFactory.new.with_params(course_params)
        factory = factory.with_params(course_params)
        expect(factory.execute).to eq(true)
        
        course = Course.first
        expect(course.name).to eq("Ruby on Rails")
        expect(course.lecturer).to eq("test")
        expect(course.description).to eq("test")
        expect(course.chapters.length).to eq(2)

        chapter1 = course.chapters.first
        expect(chapter1.name).to eq("Chapter A")
        expect(chapter1.sort_key).to eq(0)
        expect(chapter1.units.length).to eq(1)

        unit1 = chapter1.units.first
        expect(unit1.name).to eq("Unit 1")
        expect(unit1.content).to eq("Hello World")
      end
    end
  end
end
