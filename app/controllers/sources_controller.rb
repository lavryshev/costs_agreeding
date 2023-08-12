class SourcesController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_source, only: %i[edit update destroy]

  def index
    @sources = Source.all
  end

  def new
    @source = Source.new
  end

  def create
    @source = Source.new(source_params)

    if @source.save
      redirect_to sources_path, notice: 'Источник денежных средств создан успешно.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @source.update(source_params)
      redirect_to sources_path, notice: 'Источник денежных средств изменен успешно.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @source.destroy
    if @source.destroyed?
      redirect_to sources_path, notice: 'Источник денежных средств удален.'
    else
      redirect_to sources_path, notice: @source.errors.full_messages.to_sentence.capitalize
    end
  end

  private

  def source_params
    params.require(:source).permit(:name, :externalid)
  end

  def set_source
    @source = Source.find(params[:id])
  end
end
