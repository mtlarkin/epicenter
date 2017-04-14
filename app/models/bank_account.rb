class BankAccount < PaymentMethod
  before_update :verify_account, unless: 'verified'

  attr_accessor :first_deposit, :second_deposit

  def calculate_fee(_)
    0
  end

  def starting_status
    "pending"
  end

  def self.exchange_plaid_token(public_token, account_id)
    client = Plaid::Client.new(env: :sandbox, client_id: ENV['PLAID_CLIENT_ID'], secret: ENV['PLAID_SECRET_KEY'], public_key: ENV['PLAID_PUBLIC_KEY'])
    exchange_token_response = client.item.public_token.exchange(public_token)
    access_token = exchange_token_response['access_token']
    stripe_response = client.processor.stripe.bank_account_token.create(access_token, account_id)
    stripe_response['stripe_bank_account_token']
  end

private

  def verify_account
    customer = student.stripe_customer
    account = customer.bank_accounts.retrieve(stripe_id)
    begin
      account.verify(:amounts => [first_deposit.to_i, second_deposit.to_i])
      update!(verified: true)
      ensure_primary_method_exists
      true
    rescue Stripe::CardError => exception
      errors.add(:base, exception.message)
      false
    end
  end
end
