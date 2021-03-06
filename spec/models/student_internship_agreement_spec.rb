describe StudentInternshipAgreement do
  it_behaves_like 'signature', '6e5a020640d5543b6950ea229fd0e96a'

  describe '.create_from_signature_id' do
    let(:internship_course) { FactoryGirl.create(:internship_course) }
    let!(:code_review) { FactoryGirl.create(:code_review, title: 'Sign internship agreement', course: internship_course, submissions_not_required: true) }
    let(:student) { FactoryGirl.create(:student, email: 'example@example.com', courses: [internship_course]) }
    let(:signature) { FactoryGirl.create(:completed_student_internship_agreement, student: student) }
    let(:score) { FactoryGirl.create(:passing_score) }

    before do
      allow_any_instance_of(Student).to receive(:update_close_io)
    end

    it 'marks code review as passed', :stub_mailgun do
      StudentInternshipAgreement.create_from_signature_id(signature.signature_id)
      expect(Submission.find_by(student: student, code_review: code_review).meets_expectations?).to be true
    end

    it 'updates the internship agreement field in close', :stub_mailgun do
      expect_any_instance_of(Student).to receive(:update_close_io).with({ 'custom.Signed internship agreement?': 'Yes' })
      StudentInternshipAgreement.create_from_signature_id(signature.signature_id)
    end
  end
end
