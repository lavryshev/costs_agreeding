class ExpensesController < ApplicationController
  before_action :require_login
  before_action :require_agree_permission, only: %i[agree disagree]
  before_action :set_expense, only: %i[edit update destroy agree disagree]

  def index
    session['filters'] = {} if session['filters'].blank?
    session['filters'].merge!(filter_params)

    filter_by_status = [];
    if session['filters']['filter_not_agreed'].to_i == 1
      filter_by_status.push 1
    end
    if session['filters']['filter_agreed'].to_i == 1
      filter_by_status.push 2
    end
    if session['filters']['filter_rejected'].to_i == 1
      filter_by_status.push 3
    end

    if session['filters']['field']
      sort_by = session['filters']['field']
    else
      sort_by = 'created_at'
    end
    
    if filter_by_status.empty?
      @expenses = Expense.order("#{sort_by} #{session['filters']['direction']}").page params[:page]
    else
      @expenses = Expense.where(status_id: filter_by_status).order("#{sort_by} #{session['filters']['direction']}").page params[:page]
    end
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.create(expense_params)
    @expense.status = ExpenseStatus.not_agreed
    @expense.author = current_user

    if @expense.save
      redirect_to expenses_path, notice: 'Заявка создана успешно.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @expense.update(expense_params)
      redirect_to expenses_path, notice: 'Заявка изменена успешно.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: 'Заявка удалена.'
  end

  def agree
    @expense.status = ExpenseStatus.agreed
    @expense.responsible = current_user
    @expense.save
    
    add_status_change_report

    render :edit, status: :unprocessable_entity
  end

  def disagree
    @expense.status = ExpenseStatus.rejected
    @expense.responsible = current_user
    @expense.save

    add_status_change_report
    
    render :edit, status: :unprocessable_entity
  end

  private

  def expense_params
    params.require(:expense).permit(:sum, :payment_date, :description, :notes, :source_sgid)
  end

  def filter_params
    params.permit(:filter_not_agreed, :filter_agreed, :filter_rejected, :field, :direction)
  end

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def add_status_change_report
    StatusChangedReport.create(expense: @expense, responsible: @expense.responsible, status: @expense.status)
    ProcessStatusChangedReportsJob.perform_later
  end
end
