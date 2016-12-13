# encoding: utf-8

class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:show, :edit, :update, :destroy, :budget, :payments, :support]
  before_action :authenticate_user!, except: [:index, :show, :budget, :payments, :support]

#  add_breadcrumb 'Главная', :root_path
  add_breadcrumb 'Проекты', :campaigns_path

  # GET /campaigns
  # GET /campaigns.json
  def index
    @campaigns = Campaign.all
  end

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
    add_breadcrumb @campaign.title, campaign_path(@campaign)
  end

  def budget
    add_breadcrumb @campaign.title, campaign_path(@campaign)
    add_breadcrumb 'Бюджет', campaign_budget_path(@campaign)
    @budget = @campaign.budget_items.order(:is_expense)
  end

  def payments
    add_breadcrumb @campaign.title, campaign_path(@campaign)
    add_breadcrumb 'Платежи', campaign_payments_path(@campaign)
    @payments = @campaign.payments.order(time: :desc)
  end

  def support
  end

  # GET /campaigns/new
  def new
    @campaign = Campaign.new
  end

  # GET /campaigns/1/edit
  def edit
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
    @campaign = Campaign.new(campaign_params)
    unless params[:campaign][:title_image].blank?
      title_image = PostImage.new
      title_image.image = params[:campaign][:title_image][:image]
      @campaign.title_image = title_image
    end

    @campaign.budget_items << BudgetItem.new(title: 'Пожертвования', is_expense: false, amount: @campaign.target || 0)

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to @campaign, notice: 'Campaign was successfully created.' }
        format.json { render :show, status: :created, location: @campaign }
      else
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /campaigns/1
  # PATCH/PUT /campaigns/1.json
  def update

    unless params[:campaign][:title_image].blank?
      ti = PostImage.new
      @campaign.title_image = ti
      ti.image = params[:campaign][:title_image][:image]
    end

    respond_to do |format|
      if @campaign.update(campaign_params)
        format.html { redirect_to @campaign, notice: 'Campaign was successfully updated.' }
        format.json { render :show, status: :ok, location: @campaign }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaigns/1
  # DELETE /campaigns/1.json
  def destroy
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to campaigns_url, notice: 'Campaign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign
      @campaign = Campaign.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_params
      params[:campaign].permit(:title, :short_description, :description, :target, :end_date, :title_image)
    end
end
