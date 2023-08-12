class ExternalAppsController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_external_app, only: %i[edit update destroy]

  def index
    @external_apps = ExternalApp.all
  end

  def new
    @external_app = ExternalApp.new
  end

  def create
    @external_app = ExternalApp.new(external_app_params)

    if @external_app.save
      redirect_to external_apps_path, notice: 'Внешнее приложение добавлено успешно.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @external_app.update(external_app_params)
      redirect_to external_apps_path, notice: 'Внешнее приложение изменено успешно.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @external_app.destroy
    redirect_to external_apps_path, notice: 'Внешнее приложение удалено.'
  end

  private

  def external_app_params
    params.require(:external_app).permit(:name, :active, :callback_url)
  end

  def set_external_app
    @external_app = ExternalApp.find(params[:id])
  end
end
