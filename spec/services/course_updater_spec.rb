require "rails_helper"

RSpec.describe CourseUpdater do
  let!(:course) { create(:course, name: "JavaScript")}
  let!(:chapter1) { create(:chapter, course: course, name: "Draft")}
  let!(:unit1) { create(:unit, chapter: chapter1, name: "Draft")}

  let(:course_params) {
    {
      name: "Ruby on Rails",
      lecturer: "test",
      description: "test",
      chapters: chapters
    }
  }

  describe "#execute" do
    context "when update" do 
      let(:chapters) {
        [
          {
            id: chapter1.id,
            name: "Chapter A",
            units: [
              { 
                id: unit1.id,
                name: "Unit A-1",
                description: "",
                content: "Hello World",
              }
            ]
          }
        ]
      }

      it "return true" do
        expect(CourseUpdater.new(course.id, course_params).execute).to eq(true)

        course.reload
        expect(course).to have_attributes(
          name: "Ruby on Rails",
          lecturer: "test",
          description: "test"
        )

        chapter1.reload
        expect(chapter1).to have_attributes(
          name: "Chapter A",
          sort_key: 0
        )

        unit1.reload
        expect(unit1).to have_attributes(
          name: "Unit A-1",
          description: "",
          content: "Hello World",
          sort_key: 0
        )
      end

      it "the number of chapters and units remain" do
        expect{ CourseUpdater.new(course.id, course_params).execute }.to \
          change(Chapter, :count).by(0).and \
          change(Unit, :count).by(0)
      end
    end

    context "when update with a new unit" do
      let(:chapters) {
        [
          {
            id: chapter1.id,
            name: "Chapter A",
            units: [
              { 
                id: unit1.id,
                name: "Unit A-1",
                description: "",
                content: "Hello World",
              },
              { # add a new unit to the chapter
                name: "Unit A-2",
                description: "",
                content: "Hello World",
              }
            ]
          }
        ]
      }

      it "return true" do
        expect(CourseUpdater.new(course.id, course_params).execute).to eq(true)
      end

      it "increase units by 1" do
        expect{ CourseUpdater.new(course.id, course_params).execute }.to \
          change(Chapter, :count).by(0).and \
          change(Unit, :count).from(1).to(2)
      end
    end

    context "when update with a new chapter and unit" do
      let(:chapters) {
        [
          {
            id: chapter1.id,
            name: "Chapter A",
            units: [
              { 
                id: unit1.id,
                name: "Unit A-1",
                description: "",
                content: "Hello World",
              }
            ]
          },
          { # add a new chapter and unit to the course
            name: "Chapter B",
            units: [
              { 
                name: "Unit B-1",
                description: "",
                content: "Hello World",
              }
            ]
          }
        ]
      }

      it "returns true" do
        expect(CourseUpdater.new(course.id, course_params).execute).to eq(true)
      end

      it "increases the number of chapters and units" do
        expect{ CourseUpdater.new(course.id, course_params).execute }.to \
          change(Chapter, :count).from(1).to(2).and \
          change(Unit, :count).from(1).to(2)
      end
    end

    context "when update and delete a chapter" do
      let(:chapters) {
        [
          {
            id: chapter1.id,
            name: "Chapter A",
            _deleted: true, # delete the chapter 
            units: [
              { 
                id: unit1.id,
                name: "Unit A-1",
                description: "",
                content: "Hello World"
              }
            ]
          }
        ]
      }

      it "returns true" do
        expect(CourseUpdater.new(course.id, course_params).execute).to eq(true)
      end

      it "deletes the chapter and relevant units" do
        expect{ CourseUpdater.new(course.id, course_params).execute }.to \
          change(Chapter, :count).from(1).to(0).and \
          change(Unit, :count).from(1).to(0)
      end
    end

    context "when update and delete a unit" do
      let(:chapters) {
        [
          {
            id: chapter1.id,
            name: "Chapter A",
            units: [
              {  # delete the unit
                id: unit1.id,
                name: "Unit A-1",
                description: "",
                content: "Hello World",
                _deleted: true
              }
            ]
          }
        ]
      }

      it "return true" do
        expect(CourseUpdater.new(course.id, course_params).execute).to eq(true)
      end

      it "deletes the unit" do
        expect{ CourseUpdater.new(course.id, course_params).execute }.to \
          change(Unit, :count).from(1).to(0)
      end
    end
  end
end
