class BankAccountsController < ApplicationController
  before_action :set_bank_account, only: %i[edit update destroy]

  def index
    @bank_accounts = BankAccount.all
  end

  def new
    @bank_account = BankAccount.new
  end

  def create
    @bank_account = BankAccount.create(bank_account_params)

    if @bank_account.save
      redirect_to bank_accounts_path, notice: 'Банковский счет создан успешно.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @bank_account.update(bank_account_params)
      redirect_to bank_accounts_path, notice: 'Банковский счет изменен успешно.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bank_account.destroy
    redirect_to bank_accounts_path, notice: 'Банковский счет удален.'
  end

  private

  def bank_account_params
    params.require(:bank_account).permit(:name)
  end

  def set_bank_account
    @bank_account = BankAccount.find(params[:id])
  end
end
