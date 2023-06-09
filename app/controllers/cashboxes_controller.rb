class CashboxesController < ApplicationController
  before_action :require_admin
  before_action :set_cashbox, only: %i[edit update destroy]

  def index
    @cashboxes = Cashbox.all
  end

  def new
    @cashbox = Cashbox.new
  end

  def create
    @cashbox = Cashbox.create(cashbox_params)

    if @cashbox.save
      redirect_to cashboxes_path, notice: 'Касса создана успешно.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @cashbox.update(cashbox_params)
      redirect_to cashboxes_path, notice: 'Касса изменена успешно.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @cashbox.destroy
    if @cashbox.destroyed?
      redirect_to cashboxes_path, notice: 'Касса удалена.'
    else
      redirect_to cashboxes_path, notice: @cashbox.errors.full_messages.to_sentence.capitalize
    end
  end

  private

  def cashbox_params
    params.require(:cashbox).permit(:name)
  end

  def set_cashbox
    @cashbox = Cashbox.find(params[:id])
  end
end
