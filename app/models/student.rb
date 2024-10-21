class Student < ApplicationRecord
  has_one_attached :profile_picture # For ActiveStorage

  validates :first_name, :last_name, :major, presence: true, length: { in: 2..25 }
  validates :school_email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@msudenver.edu\z/i, message: "must be a valid MSU Denver email" }
  validates :graduation_date, presence: true

  VALID_MAJORS = ["Computer Engineering BS", "Computer Information Systems BS", "Computer Science BS", "Cybersecurity Major", "Data Science and Machine Learning Major"]

  validates :major, inclusion: {in: VALID_MAJORS, message: "%{value} is not a valid major" }

  def self.search(params)
    students = all

    # Check for the major search
    if params[:major].present?
      students = students.where(major: params[:major])
    end

    if params[:graduation_date_option].present? && params[:graduation_date].present?
      if params[:graduation_date_option] == 'before'
        students = students.where('graduation_date < ?', params[:graduation_date])
      elsif params[:graduation_date_option] == 'after'
        students = students.where('graduation_date > ?', params[:graduation_date])
      end
    end

    students
  end
end