describe Internship do
  it { should belong_to :company }
  it { should have_many :ratings }
  it { should have_many :interview_assignments }
  it { should have_many :internship_assignments }
  it { should have_many(:courses).through(:course_internships) }
  it { should have_many(:students).through(:ratings) }
  it { should have_many(:tracks).through(:internship_tracks) }
  it { should validate_presence_of :courses }
  it { should validate_presence_of :description }
  it { should validate_presence_of :ideal_intern }
  it { should validate_presence_of :name }
  it { should validate_presence_of :website }
  it { should validate_presence_of :number_of_students }
  it { should validate_presence_of :tracks }

  describe 'validations' do
    it 'returns false if an internship is saved with number_of_students not equal to 2, 4, or 6' do
      course = FactoryGirl.create(:internship_course)
      track = FactoryGirl.create(:track)
      internship = FactoryGirl.build(:internship, courses: [course], tracks: [track], number_of_students: 5)
      expect(internship.save).to eq false
    end
  end

  describe '#assigned_as_interview_for' do
    let(:assigned_internship) { FactoryGirl.create(:internship) }
    let(:student) { FactoryGirl.create(:student, courses: [assigned_internship.courses.first]) }

    it "returns internships that a student doesn't have assigned interviews with" do
      FactoryGirl.create(:internship)
      FactoryGirl.create(:interview_assignment, student_id: student.id, internship_id: assigned_internship.id)
      expect(Internship.assigned_as_interview_for(student)).to eq [assigned_internship]
    end
  end

  describe '#not_assigned_as_interview_for' do
    let(:internship) { FactoryGirl.create(:internship) }
    let(:internship_2) { FactoryGirl.create(:internship) }
    let(:student) { FactoryGirl.create(:student, courses: [internship.courses.first, internship_2.courses.first]) }

    it "returns internships that a student doesn't have assigned interviews with" do
      FactoryGirl.create(:interview_assignment, student_id: student.id, internship_id: internship.id)
      expect(Internship.not_assigned_as_interview_for(student)).to eq [internship_2]
    end
  end

  describe '#fix_url' do
    it 'strips whitespace from url' do
      internship = FactoryGirl.create(:internship, website: 'http://www.test.com    ')
      expect(internship.website).to eq 'http://www.test.com'
    end

    it 'returns false with invalid url' do
      internship = FactoryGirl.build(:internship, website: 'http://].com')
      expect(internship.save).to eq false
    end

    context 'with a valid uri scheme' do
      it "doesn't prepend 'http://' to the url when it starts with 'http:/" do
        internship = FactoryGirl.create(:internship, website: 'http://www.test.com')
        expect(internship.website).to eq 'http://www.test.com'
      end
    end

    context 'with an invalid uri scheme' do
      it "prepends 'http://' to the url when it doesn't start with 'http" do
        internship = FactoryGirl.create(:internship, website: 'www.test.com')
        expect(internship.website).to eq 'http://www.test.com'
      end
    end
  end

  describe 'other_internship_courses' do
    it 'returns all internship courses not associated with the internship' do
      internship = FactoryGirl.create(:internship)
      other_internship_course = FactoryGirl.create(:internship_course)
      expect(internship.other_internship_courses).to eq [other_internship_course]
    end
  end

  describe '#tracks_ordered_by_description' do
    it 'returns the track descriptions for an internship ordered by description' do
      php_track = FactoryGirl.create(:track, description: 'PHP/Drupal')
      internship = FactoryGirl.create(:internship, tracks: [php_track])
      expect(internship.tracks_ordered_by_description).to eq 'PHP/Drupal, Ruby/Rails'
    end
  end
end
