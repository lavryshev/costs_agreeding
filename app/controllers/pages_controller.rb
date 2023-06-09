class PagesController < ApplicationController
  before_action :require_login

  def home
    @expenses = Expense.all
  end

  def permission_error
  end
end
