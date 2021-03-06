class Track < ActiveRecord::Base
  has_many :internship_tracks
  has_many :internships, through: :internship_tracks
  has_and_belongs_to_many :languages
  has_many :courses
  has_many :cohorts
end
