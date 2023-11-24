require "rails_helper"

RSpec.describe "Api::V1::Courses", type: :request do
  
  describe "GET /courses" do
    let!(:courses) { create_list(:course, 25, :with_course_details) }

    context "without pagination params" do
      it 'returns courses with chapters and units' do
        get "/api/v1/courses"

        expect(response).to have_http_status(:ok)

        courses = JSON.parse(response.body, symbolize_names: true)[:courses]
        expect(courses.length).to eq(15)
      end
    end

    context "with pagination params" do
      it 'returns courses with chapters and units' do
        get "/api/v1//courses", params: { page: 2, per_page: 10 }

        expect(response).to have_http_status(:ok)
        
        courses = JSON.parse(response.body, symbolize_names: true)[:courses]
        expect(courses.length).to eq(10)
      end
    end
  end

  describe "POST /courses" do
    context "with valid params" do
      let(:course_params) {
        {
          course: {
            name: "Ruby on Rails",
            lecturer: "New Lecturer",
            description: "New Description",
            chapters: [
              {
                name: "Chapter 1",
                sort_key: 1,
                units: [
                  {
                    name: "Unit 1",
                    description: "Description 1",
                    content: "Content 1",
                    sort_key: 1
                  },
                  {
                    name: "Unit 2",
                    description: "Description 2",
                    content: "Content 2",
                    sort_key: 2
                  }
                ]
              }
            ]
          }
        }
      }

      context "with valid params" do
        it "resturns message and a 200 status" do
          post "/api/v1/courses", params: course_params
          expect(response).to have_http_status(:ok)
          expect(response.body).to eq({message: "Created the course, relevant chapters, and units"}.to_json)
        end
      end      
      
      xcontext "with invalid params" do
        it "resturns error and a 422 status" do
          post "/api/v1/courses", params: course_params
          expect(response).to have_http_status(422)
          # expect(response.body).to eq({message: "Created the course, relevant chapters, and units"}.to_json)
        end
      end 
    end
  end

  describe "GET /courses/:id" do
    before { FactoryBot.rewind_sequences }

    let!(:course) { create(:course, name: "Ruby on Rails") }
    let!(:chapter1) { create(:chapter, course: course, sort_key: 0) }
    let!(:chapter2) { create(:chapter, course: course, sort_key: 1) }
    let!(:unit1) { create(:unit, chapter: chapter1, sort_key: 1) }
    let!(:unit2) { create(:unit, chapter: chapter2, sort_key: 1) }

    context "when the course exists" do
      it "returns course with chapters, units, and a 200 status" do
        get "/api/v1/courses/#{course.id}"

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body, symbolize_names: true)).to eq(
          {
            course: {
              id: course.id,
              name: "Ruby on Rails",
              lecturer: "lecturer 1",
              description: "description 1",
              chapters: [
                {
                  id: chapter1.id, 
                  name: "chapter 1", 
                  sort_key: 0, 
                  units: [
                    { 
                      id: unit1.id, 
                      name: "unit 1", 
                      content: "unit 1 content", 
                      description: "unit 1 description", 
                      sort_key: 1 
                    }
                  ]
                }, 
                { 
                  id: chapter2.id, 
                  name: "chapter 2", 
                  sort_key: 1, 
                  units: [
                    { 
                      id: unit2.id, 
                      name: "unit 2", 
                      content: "unit 2 content", 
                      description: "unit 2 description", 
                      sort_key: 1 
                    }
                  ]
                }
              ]
            }
          }
        )
      end
    end

    context "when the course doesn't exist" do
      it "returns error and a 404 status" do
        get "/api/v1/courses/2"
        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq({error: "Record not found"}.to_json)
      end
    end
  end

  describe "PATH /courses/:id" do
    let!(:course) { create(:course, name: "JavaScript")}
    let!(:chapter1) { create(:chapter, course: course, name: "Draft")}
    let!(:unit1) { create(:unit, chapter: chapter1, name: "Draft")}

    context "with valid params" do
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
        expect(response.body).to eq({message: "Updated the course, relevant chapters, and units"}.to_json)
      end
    end
  end

  describe "DELETE /courses/:id" do
    let!(:course) { create(:course)}
    let!(:chapter) { create(:chapter, course: course)}
    let!(:units) { create_list(:unit, 2, chapter: chapter)}

    context "when the course exists" do
      it "returns message and a 200 status" do
        delete "/api/v1/courses/#{course.id}" 
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({message: "Deleted the course, relevant chapters, and units"}.to_json)
      end

      it "removes the course, relevant chapters, and units" do
        expect{ delete "/api/v1/courses/#{course.id}" }.to \
          change(Course, :count).from(1).to(0).and \
          change(Chapter, :count).from(1).to(0).and \
          change(Unit, :count).from(2).to(0)
      end
    end
  end
end
