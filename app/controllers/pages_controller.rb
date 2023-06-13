class PagesController < ApplicationController
  before_action :require_login

  def home
    redirect_to expenses_path
  end

  def permission_error
  end
end
