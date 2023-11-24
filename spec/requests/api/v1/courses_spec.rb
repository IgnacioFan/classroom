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
end
