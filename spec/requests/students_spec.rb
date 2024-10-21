require 'rails_helper'

RSpec.describe "Students", type: :request do
  describe "GET /students" do
    it "returns students who graduated after a specific date" do
      # Create students with different graduation dates
      student1 = Student.create!(first_name: "John", last_name: "Doe", major: "CS", graduation_date: "2022-05-20")
      student2 = Student.create!(first_name: "Jane", last_name: "Smith", major: "Math", graduation_date: "2023-05-20")

      # Perform the search by a graduation date after 2022
      get "/students", params: { graduation_date_after: "2022-12-31" }

      # Expect to receive only the second student in the response
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.size).to eq(1)
      expect(json[0]["first_name"]).to eq("Jane")
    end
  end

  describe "POST /students" do
    it "creates a new student with valid parameters" do
      student_params = {
        student: {
          first_name: "Alice",
          last_name: "Johnson",
          major: "Engineering",
          graduation_date: "2024-05-20"
        }
      }

      post "/students", params: student_params

      expect(response).to have_http_status(201)
      json = JSON.parse(response.body)
      expect(json["first_name"]).to eq("Alice")
    end

    it "does not create a student with invalid parameters" do
      invalid_params = {
        student: {
          first_name: "",  # Invalid: first name can't be blank
          last_name: "Johnson",
          major: "Engineering",
          graduation_date: "2024-05-20"
        }
      }

      post "/students", params: invalid_params

      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("First name can't be blank")
    end
  end

  describe "GET /students/:id" do
    it "fetches a student's details successfully" do
      student = Student.create!(first_name: "John", last_name: "Doe", major: "CS", graduation_date: "2022-05-20")
      
      get "/students/#{student.id}"

      expect(response).to have_http_status(200)
    end

    it "returns the correct student details" do
      student = Student.create!(first_name: "John", last_name: "Doe", major: "CS", graduation_date: "2022-05-20")

      get "/students/#{student.id}"

      json = JSON.parse(response.body)
      expect(json["first_name"]).to eq("John")
      expect(json["last_name"]).to eq("Doe")
    end

    it "returns a 404 if the student does not exist" do
      get "/students/999"  # Non-existent ID

      expect(response).to have_http_status(404)
    end
  end

  describe "DELETE /students/:id" do
    it "deletes a student successfully" do
      student = Student.create!(first_name: "John", last_name: "Doe", major: "CS", graduation_date: "2022-05-20")

      delete "/students/#{student.id}"

      expect(response).to have_http_status(302)  # Expect a redirect
      follow_redirect!
      expect(response.body).to include("Student was successfully deleted")
    end

    it "returns a 404 if trying to delete a non-existent student" do
      delete "/students/999"  # Non-existent ID

      expect(response).to have_http_status(404)
    end
  end
end
