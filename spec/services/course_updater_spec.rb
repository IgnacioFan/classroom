require "rails_helper"

RSpec.describe CourseUpdater do

  describe "#execute" do
    let!(:course) { create(:course, name: "JavaScript")}
    let!(:chapter1) { create(:chapter, course: course, name: "Draft")}
    let!(:unit1) { create(:unit, chapter: chapter1, name: "Draft")}
    
    context "when update existed chapters and units" do 
      let(:course_params) {
        {
          name: "Ruby on Rails",
          lecturer: "test",
          description: "test",
          chapters: [
            {
              id: chapter1.id,
              name: "Chapter A",
              sort_key: 0,
              units: [
                {
                  id: unit1.id,
                  name: "Unit A-1",
                  description: "",
                  content: "Hello World",
                  sort_key: 0
                }
              ]
            }
          ]
        }
      }
      it "return true" do
        res = CourseUpdater.new.execute(course.id, course_params)
        expect(res).to eq(true)

        course.reload
        expect(course.name).to eq("Ruby on Rails")
        expect(course.chapters.length).to eq(1)

        chapter1.reload
        expect(chapter1.name).to eq("Chapter A")

        unit1.reload
        expect(unit1.name).to eq("Unit A-1")
      end
    end

    context "when update non-existed chapters and units" do 
      let(:course_params) {
        {
          name: "Ruby on Rails",
          lecturer: "test",
          description: "test",
          chapters: [
            {
              id: nil,
              name: "Chapter B",
              sort_key: 1,
              units: [
                {
                  name: "Unit B-1",
                  description: "",
                  content: "Hello World",
                  sort_key: 0
                },
                {
                  name: "Unit B-2",
                  description: "",
                  content: "Hello World",
                  sort_key: 1
                }
              ]
            }
          ]
        }
      }
      it "return true" do
        res = CourseUpdater.new.execute(course.id, course_params)
        expect(res).to eq(true)

        course.reload
        expect(course.name).to eq("Ruby on Rails")
        expect(course.chapters.length).to eq(2)

        chapter2 = course.chapters.last
        expect(chapter2.name).to eq("Chapter B")
        expect(chapter2.units.length).to eq(2)
        
        unit2 = chapter2.units.first
        expect(unit2.name).to eq("Unit B-1")
      end
    end
  end
end
