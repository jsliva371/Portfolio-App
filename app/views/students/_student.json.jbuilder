json.extract! student, :id, :first_name, :last_name, :school_email, :major, :graduation_date, :created_at, :updated_at
json.url student_url(student, format: :json)
