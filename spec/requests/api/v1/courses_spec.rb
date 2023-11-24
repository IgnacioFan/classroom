require "rails_helper"

RSpec.describe "Api::V1::Courses", type: :request do
  describe "POST /courses" do
    context "with valid parameters" do
      let(:course_params) {
        {
          course: {
            name: "Rails",
            lecturer: "test",
            description: "test",
            chapters: [
              {
                name: "Chapter A",
                sort_key: 0,
                units: [
                  {
                    name: "Unit 1",
                    description: "Unit 1 Description",
                    content: "Unit 1 Content",
                    sort_key: 0,
                  }
                ]
              }
            ]
          }
        }
      }

      it "creates a new course" do
        post "/api/v1/courses", params: course_params
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({message: "Successfully create course, chapters, and units"}.to_json)
      end
    end
  end

  describe "GET /courses/:id" do
    let!(:course) { create(:course, name: "Ruby on Rails") }
    let!(:chapter1) { create(:chapter, course: course, sort_key: 0) }
    let!(:chapter2) { create(:chapter, course: course, sort_key: 1) }
    let!(:unit1) { create(:unit, chapter: chapter1, sort_key: 1) }
    let!(:unit2) { create(:unit, chapter: chapter2, sort_key: 1) }

    it "reates a new course" do
      get "/api/v1/courses/#{course.id}"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body, symbolize_names: true)).to eq(
        {
          course: {
            id: course.id,
            name: "Ruby on Rails",
            lecturer: "lecturer1",
            description: "description1",
            chapters: [
              {
                id: chapter1.id, 
                name: "chapter1", 
                sort_key: 0, 
                units: [
                  { id: unit1.id, name: "unit 1", content: "unit 1 content", description: "unit 1 description", sort_key: 1 }
                ]
              }, 
              { 
                id: chapter2.id, 
                name: "chapter2", 
                sort_key: 1, 
                units: [
                  { id: unit2.id, name: "unit 2", content: "unit 2 content", description: "unit 2 description", sort_key: 1 }
                ]
              }
            ]
          }
        }
      )
    end
  end

  describe "PATH /courses/:id" do
    let!(:course) { create(:course, name: "JavaScript")}
    let!(:chapter1) { create(:chapter, course: course, name: "Draft")}
    let!(:unit1) { create(:unit, chapter: chapter1, name: "Draft")}

    context "with valid parameters" do
      let(:course_params) {
        {
          course: {
            name: "Rails",
            lecturer: "Test",
            description: "test test test",
            chapters: [
              {
                id: chapter1.id,
                name: "Chapter A",
                sort_key: 0,
                units: [
                  { id: unit1.id, name: "Unit A-1", description: "test 1", content: "test 1", sort_key: 0 },
                  { id: nil, name: "Unit A-2", description: "test 2", content: "test 2", sort_key: 1 }
                ]
              }
            ]
          }
        }
      }

      it "creates a new course" do
        patch "/api/v1/courses/#{course.id}", params: course_params
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({message: "Successfully update course, chapters, and units"}.to_json)
      end
    end
  end

  describe "DELETE /courses/:id" do
    let!(:course) { create(:course)}
    let!(:chapter) { create(:chapter, course: course)}
    let!(:units) { create_list(:unit, 2, chapter: chapter)}

    context "when the course exists" do
      it "return message and 200 status" do
        delete "/api/v1/courses/#{course.id}" 
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({message: "Deleted the course, relevant chapters, and units"}.to_json)
      end

      it "remove the course, relevant chapters, and units" do
        expect{ delete "/api/v1/courses/#{course.id}" }.to \
          change(Course, :count).from(1).to(0).and \
          change(Chapter, :count).from(1).to(0).and \
          change(Unit, :count).from(2).to(0)
      end
    end

    context "when the course doesn't exist" do
      it "return error message and 404 status" do
        delete "/api/v1/courses/2"
        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq({message: "Record not found"}.to_json)
      end
    end
  end
end
