class BankAccountsController < ApplicationController
  before_action :require_login
  before_action :require_admin
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
    if @bank_account.destroyed?
      redirect_to bank_accounts_path, notice: 'Банковский счет удален.'
    else
      redirect_to bank_accounts_path, notice: @bank_account.errors.full_messages.to_sentence.capitalize
    end
  end

  private

  def bank_account_params
    params.require(:bank_account).permit(:name)
  end

  def set_bank_account
    @bank_account = BankAccount.find(params[:id])
  end
end
