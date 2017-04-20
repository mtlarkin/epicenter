feature 'Creating a bank account manually' do
  scenario 'as a guest' do
    visit new_bank_account_path
    expect(page).to have_content 'need to sign in'
  end

  context 'as a student' do
    before do
      student = FactoryGirl.create(:student)
      login_as(student, scope: :student)
      visit new_bank_account_path
      click_on 'Enter bank account info manually'
      fill_in 'Name on account', with: student.name
      select 'Individual'
    end

    scenario 'with valid information', :vcr, :js do
      fill_in 'Routing number', with: '110000000'
      fill_in 'Bank account number', with: '000123456789'
      click_on 'Verify bank account'
      expect(page).to have_content '2-3 business days'
    end

    scenario 'with missing account number', :vcr, :js do
      fill_in 'Routing number', with: '110000000'
      fill_in 'Bank account number', with: ' '
      click_on 'Verify bank account'
      within '.alert-danger' do
        expect(page).to have_content 'Invalid bank account number.'
      end
    end

    scenario 'with invalid routing number', :vcr, :js do
      fill_in 'Bank account number', with: '000123456789'
      fill_in 'Routing number', with: '12345689'
      click_on 'Verify bank account'
      within '.alert-danger' do
        expect(page).to have_content 'Invalid routing number.'
      end
    end
  end
end

feature 'Verifying a bank account' do
  context 'as a student' do
    context 'with correct deposit amounts' do
      let(:student) { FactoryGirl.create :user_with_unverified_bank_account, plan: plan }
      let(:plan) { FactoryGirl.create :upfront_payment_only_plan }

      before do
        login_as(student, scope: :student)
        visit payment_methods_path
        click_on 'Verify Account'
        fill_in 'First deposit amount', with: 32
        fill_in 'Second deposit amount', with: 45
        click_on 'Confirm account'
      end

      it 'gives the student a confirmation notice and redirects to payments page', :vcr, js: true do
        expect(page).to have_content 'account has been confirmed'
        expect(current_path).to eq payment_methods_path
      end
    end

    context 'with incorrect deposit amounts' do
      it 'gives an error notice', :vcr, js: true do
        student = FactoryGirl.create :user_with_unverified_bank_account
        login_as(student, scope: :student)
        visit payment_methods_path
        click_on 'Verify Account'
        fill_in 'First deposit amount', with: 16
        fill_in 'Second deposit amount', with: 78
        click_on 'Confirm account'
        expect(page).to have_content 'The amounts provided do not match the amounts that were sent to the bank account.'
      end
    end
  end
end

# feature 'Creating a bank account via plaid' do
#   context 'as a student' do
#     before do
#       student = FactoryGirl.create(:student)
#       login_as(student, scope: :student)
#       visit new_bank_account_path
#       click_on 'Link bank account instantly'
#     end
#
#     scenario 'with valid information', :vcr, :js do
#       save_and_open_screenshot
#     end
#   end
# end
