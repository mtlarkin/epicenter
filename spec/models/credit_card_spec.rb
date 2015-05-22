describe CreditCard do
  it { should belong_to :student }
  it { should have_many :payments }
  it { should validate_presence_of :student_id }

  describe "create Stripe card", :vcr do
    context "with a valid number" do
      let(:credit_card) { FactoryGirl.create :credit_card }

      it "creates a Stripe card for a Stripe customer", :vcr do
        credit_card = FactoryGirl.create(:credit_card)
        stripe_card = credit_card.student.stripe_customer.sources.all.first
        expect(stripe_card).to be_an_instance_of(Stripe::Card)
      end

      it "won't save the credit card if it is invalid" do
        credit_card = FactoryGirl.build(:invalid_credit_card)
        expect(credit_card.id).to eq nil
      end

      it "sets verified to 'true' before_create", :vcr do
        credit_card = FactoryGirl.create(:credit_card)
        expect(credit_card.verified).to eq true
      end

      it "gets last four digits after_create", :vcr do
        credit_card = FactoryGirl.create(:credit_card)
        expect(credit_card.last_four_string).to eq "4242"
      end

      it "is made the primary payment method if student does not have one" do
        credit_card = FactoryGirl.create(:credit_card)
        expect(credit_card.student.primary_payment_method).to eq credit_card
      end
    end
  end

  describe "#starting_status" do
    it "returns 'succeeded'", :vcr do
      credit_card = FactoryGirl.create :credit_card
      expect(credit_card.starting_status).to eq 'succeeded'
    end
  end

  describe "#calculate_fee" do
    it "returns the credit card fees for the amount given", :vcr do
      credit_card = FactoryGirl.create :credit_card
      expect(credit_card.calculate_fee(600_00)).to eq 18_21
    end
  end

  describe "#verified?" do
    it "returns true", :vcr do
      credit_card = FactoryGirl.create :credit_card
      expect(credit_card.verified?).to eq true
    end
  end
end
