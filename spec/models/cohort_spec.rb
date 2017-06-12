describe Cohort do
  it { should have_many :courses }
  it { should belong_to :office }
  it { should belong_to :track }
  it { should belong_to :admin }
  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:office) }

  describe '.create_from_course_ids' do
    let(:course) { FactoryGirl.create(:course) }
    let(:future_course) { FactoryGirl.create(:future_course) }

    it 'creates cohort for specific track' do
      track = FactoryGirl.create(:track)
      cohort_data = { start_month: "2017-01", office: course.office.name, track: track.description, courses: [course.id, future_course.id] }
      Cohort.create_from_course_ids(cohort_data)
      cohort = Cohort.first
      expect(cohort.description).to eq "2017-01 #{track.description} #{course.office.name}"
      expect(cohort.office).to eq course.office
      expect(cohort.start_date).to eq course.start_date
      expect(cohort.end_date).to eq future_course.end_date
      expect(cohort.track).to eq track
    end

    it 'creates cohort not for specific track' do
      cohort_data = { start_month: "2017-01", office: course.office.name, track: "ALL", courses: [course.id, future_course.id] }
      Cohort.create_from_course_ids(cohort_data)
      cohort = Cohort.first
      expect(cohort.description).to eq "2017-01 ALL #{course.office.name}"
      expect(cohort.office).to eq course.office
      expect(cohort.start_date).to eq course.start_date
      expect(cohort.end_date).to eq future_course.end_date
    end
  end

  describe 'creating a cohort' do
    let(:track) { FactoryGirl.create(:track) }
    let(:admin) { FactoryGirl.create(:admin) }
    let(:office) { FactoryGirl.create(:portland_office) }

    it 'creates a cohort when classes already exist' do
      course = FactoryGirl.create(:course, track: track, admin: admin, office: office)
      future_course = FactoryGirl.create(:course, track: track, admin: admin, office: office)
      cohort = Cohort.create(track: track, admin: admin, office: office, start_date: course.start_date)
      expect(cohort.description).to eq "#{course.start_date.strftime('%Y-%m')} #{course.track.description} #{course.office.name}"
      expect(cohort.office).to eq course.office
      expect(cohort.track).to eq course.track
      expect(cohort.start_date).to eq course.start_date
      expect(cohort.courses).to include(course)
      expect(cohort.courses).to include(future_course)
    end

    it 'creates a cohort when classes do not yet exist' do
      cohort = Cohort.create(track: track, admin: admin, office: office, start_date: Date.today)
      expect(cohort.description).to eq "#{Date.today.strftime('%Y-%m')} #{track.description} #{office.name}"
      expect(cohort.office).to eq office
      expect(cohort.track).to eq track
      expect(cohort.start_date).to eq Date.today
      expect(cohort.courses.count).to eq 5
    end
  end

end
