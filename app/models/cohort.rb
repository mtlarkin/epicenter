class Cohort < ActiveRecord::Base
  validates :start_date, presence: true
  validates :office, presence: true

  default_scope { order(:start_date) }

  has_many :courses, -> { order(:end_date) }
  belongs_to :office
  belongs_to :track
  belongs_to :admin

  before_create :find_or_create_courses, if: ->(cohort) { cohort.courses.empty? }
  before_create :set_description, if: ->(cohort) { cohort.description.blank? }

  def self.create_from_course_ids(attributes)
    description = "#{attributes[:start_month]} #{attributes[:track]} #{attributes[:office]}"
    office = Office.find_by(name: attributes[:office])
    track = Track.find_by(description: attributes[:track]) unless attributes[:track] == "ALL"
    course_ids = attributes[:courses]
    courses = course_ids.map { |id| Course.find(id) }.sort_by { |course| course.start_date }
    start_date = courses.first.start_date
    cohort = Cohort.create(description: description, office: office, track: track, start_date: start_date, courses: courses)
    cohort.courses.update_all(track_id: track.id) if track
  end

private

  def find_or_create_courses
    next_course_start_date = start_date
    binding.pry
    5.times do |level|
      course = Course.find_or_create_by({ language: track.languages.find_by(level: level), start_date: skip_holidays(next_course_start_date), office: office, track: track, start_time: '8:00 AM', end_time: '5:00 PM' }) do |course|
        course.admin = admin
        course.class_days = level == 4 ? calculate_internship_class_days(next_course_start_date) : calculate_class_days(next_course_start_date)
        course.save
      end
      next_course_start_date = course.end_date.next_week
      self.courses << course
    end
  end

  # do not include last friday
  def calculate_class_days(start_date)
    class_days = []
    day = start_date
    24.times do
      while day.saturday? || day.sunday? || Rails.configuration.holiday_weeks.include?(day.strftime('%Y-%m-%d')) do
        day = day.next_week
      end
      class_days << day unless Rails.configuration.holidays.include? day.strftime('%Y-%m-%d')
      day = day.next
    end
    class_days
  end

  # ignores holiday_weeks, since internships may not follow them
  def calculate_internship_class_days(start_date)
    class_days = []
    day = start_date
    35.times do
      day = day.next_week if day.saturday? || day.sunday?
      class_days << day unless Rails.configuration.holidays.include? day.strftime('%Y-%m-%d')
      day = day.next
    end
    class_days
  end

  def skip_holidays(day)
    while day.saturday? || day.sunday? || Rails.configuration.holidays.include?(day.strftime('%Y-%m-%d')) || Rails.configuration.holiday_weeks.include?(day.monday.strftime('%Y-%m-%d')) do
      day = day.next
    end
    day
  end

  def set_description
    self.description = "#{start_date.strftime('%Y-%m')} #{track.description} #{office.name}"
  end
end
