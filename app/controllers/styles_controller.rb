class StylesController < ApplicationController
  authorize! :admin

  before_action :init_style, only: %i[edit update destroy]

  def index
    @styles = Style.all
  end

  def new
    @style = Style.new
  end

  def create
    @style = Style.new(style_params)
    if @style.valid?
      @style.save
      redirect_to edit_style_path(@style)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @style.update_attributes(style_params)
      redirect_to styles_path
    else
      render :edit
    end
  end

  def destroy
    @style.destroy if @style.lessons.length <= 0
    redirect_to styles_path
  end

  private

  def init_style
    @style = Style.find params[:id]
    redirect_to :index if @style.nil?
  end

  def style_params
    p = params.require(:style).permit(:name, :duration_hours, :calculate_payrolls, teacher_ids: [])
    p[:teacher_ids] = p[:teacher_ids].reject(&:blank?)
    p
  end
end
