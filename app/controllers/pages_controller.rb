class PagesController < ApplicationController
  def home
    @expenses = Expense.all
  end
end
