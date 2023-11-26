require "rails_helper"

RSpec.describe CourseFactory do
  let(:course_params) {
    {
      name: "Ruby on Rails",
      lecturer: "DHH",
      description: "test",
      chapters: [
        {
          name: "Chapter A",
          units: [
            {
              name: "Unit 1",
              description: "",
              content: "Hello World"
            }
          ]
        },
        {
          name: "Chapter B",
          units: [
            {
              name: "Unit 2",
              description: "",
              content: "Hello World"
            }
          ]
        }
      ]
    }
  }

  describe "#execute" do
    context "when create the course, chapters, and units" do 
      it "returns true" do
        expect(CourseFactory.new(course_params).execute).to eq(true)

        course = Course.first
        expect(course).to have_attributes(
          name: "Ruby on Rails",
          lecturer: "DHH",
          description: "test"
        )
        chapter1 = course.chapters.first
        expect(chapter1).to have_attributes(
          name: "Chapter A",
          sort_key: 0
        )
        chapter2 = course.chapters.second
        expect(chapter2).to have_attributes(
          name: "Chapter B",
          sort_key: 1
        )
        unit1 = chapter1.units.first
        expect(unit1).to have_attributes(
          name: "Unit 1",
          content: "Hello World",
          sort_key: 0
        )
        unit2 = chapter2.units.first
        expect(unit2).to have_attributes(
          name: "Unit 2",
          content: "Hello World",
          sort_key: 0
        )
      end
    end

    it "increases the number of course, chapters and units" do
      expect{ CourseFactory.new(course_params).execute }.to \
        change(Course, :count).from(0).to(1).and \
        change(Chapter, :count).from(0).to(2).and \
        change(Unit, :count).from(0).to(2)
    end
  end
end
