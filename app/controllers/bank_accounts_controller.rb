class BankAccountsController < ApplicationController
  authorize_resource

  def new
    @bank_account = BankAccount.new
  end

  def create
    if params[:public_token] && params[:account_id] # Creating bank account through Plaid
      stripe_token = BankAccount.exchange_plaid_token(params[:public_token], params[:account_id])
      @bank_account = BankAccount.new( {stripe_token: stripe_token, student: current_student, verified: true} )
      if @bank_account.save
        @bank_account.ensure_primary_method_exists
        flash[:notice] = "Your bank account has been confirmed."
      else
        flash[:alert] = "There was a problem linking your bank account."
      end
      render js: "window.location.pathname ='#{payment_methods_path}'"
    else # Creating bank account manually
      @bank_account = BankAccount.new(bank_account_params.merge(student: current_student))
      unless @bank_account.save
        render :new
      end
    end
  end

  def edit
    @bank_account = BankAccount.find(params[:id])
  end

  def update
    @bank_account = BankAccount.find(params[:id])
    if @bank_account.update(bank_account_params)
      redirect_to payment_methods_path, notice: "Your bank account has been confirmed."
    else
      render :edit
    end
  end

private
  def bank_account_params
    params.require(:bank_account).permit(:first_deposit, :second_deposit, :stripe_token)
  end
end
