class Admin < User
  default_scope { order(:name) }

  belongs_to :current_course, class_name: 'Course'
  has_many :courses
  has_many :cohorts

  before_create :assign_current_course
  devise :database_authenticatable, :validatable
  include DeviseInvitable::Inviter

  def other_courses
    Course.where.not(id: courses.map(&:id)).includes(:admin).includes(:office)
  end

private

  def assign_current_course
    self.current_course = Course.last
  end
end
