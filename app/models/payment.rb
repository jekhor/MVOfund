class Payment < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :budget_item

  validates :time, presence: true
  validates :amount, presence: true
  validates :amount, numericality: {other_than: 0}
  validates :campaign, presence: true

  #TODO: validate if campaign and budget_item.campaign are same

  def self.earnings_amount(campaign=nil)
    self.calculate_sum(true, campaign)
  end

  def self.expenses_amount(campaign=nil)
    self.calculate_sum(false, campaign)
  end

  def self.earnings(campaign=nil)
    self.earnings_or_expenses(true, campaign)
  end

  def self.expenses(campaign=nil)
    self.earnings_or_expenses(false, campaign)
  end

  private

  def self.earnings_or_expenses(earnings = true, campaign=nil)
    if campaign.kind_of? Numeric
      campaign = Campaign.find campaign
    end

    if earnings
      cond = 'amount > 0'
    else
      cond = 'amount < 0'
    end

    if campaign.nil?
      Payment.where(cond)
    else
      Payment.where(cond + ' AND campaign_id = ?', campaign.id)
    end
  end

  def self.calculate_sum(earnings=true, campaign=nil)
    if campaign.kind_of? Numeric
      campaign = Campaign.find campaign
    end

    if earnings
      cond = 'amount > 0'
    else
      cond = 'amount < 0'
    end

    if campaign.nil?
      res = self.select('sum(amount) AS sum').where(cond)
    else
      res = self.select('sum(amount) AS sum').where(cond + ' AND campaign_id = ?', campaign.id).group(:campaign_id)
    end

    sum = 0
    sum = res.first.sum unless res.empty?
    sum.abs
  end
end
