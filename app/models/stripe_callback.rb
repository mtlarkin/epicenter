class StripeCallback
  include ActiveModel::Model

  def initialize(params)
    event = params
    check_event_type(event)
  end

private

  def check_event_type(event)
    if event["type"] == "charge.succeeded" && stripe_transaction(event) != nil
      update_payment_status(event, "succeeded")
    elsif event["type"] == "charge.failed" && stripe_transaction(event) != nil
      update_payment_status(event, "failed")
    end
  end

  def update_payment_status(event, status)
    payment = Payment.find_by(stripe_transaction: stripe_transaction(event))
    if payment && payment.status == "pending"
      Rails.logger.info "Stripe Callback: updating #{stripe_transaction(event)} to #{status}"
      payment.try(:update, status: status)
    elsif payment
      Rails.logger.info "Ignoring callback: #{stripe_transaction(event)} status was not pending"
    else
      Rails.logger.info "Ignoring callback: #{stripe_transaction(event)} not found"
    end
  end

  def stripe_transaction(event)
    event["data"]["object"]["balance_transaction"]
  end
end
