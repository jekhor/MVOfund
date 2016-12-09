module FinanceRecord
  extend ActiveSupport::Concern

  class_methods do
    def earnings_amount(campaign=nil)
      calculate_sum(true, campaign)
    end

    def expenses_amount(campaign=nil)
      calculate_sum(false, campaign)
    end

    def earnings(campaign=nil)
      earnings_or_expenses(true, campaign)
    end

    def expenses(campaign=nil)
      earnings_or_expenses(false, campaign)
    end

    private

    def earnings_or_expenses(earnings = true, campaign=nil)
      if campaign.kind_of? Numeric
        campaign = Campaign.find campaign
      end

      if campaign.nil?
        where('is_expense = ?', !earnings)
      else
        where('is_expense = ? AND campaign_id = ?', !earnings, campaign.id)
      end
    end

    def calculate_sum(earnings=true, campaign=nil)
      if campaign.kind_of? Numeric
        campaign = Campaign.find campaign
      end

      if campaign.nil?
        res = select('sum(amount) AS sum').where('is_expense = ?', !earnings)
      else
        res = select('sum(amount) AS sum').where('is_expense = ? AND campaign_id = ?', !earnings, campaign.id).group(:campaign_id)
      end

      sum = 0
      sum = res.first.sum unless res.empty?
      sum.abs
    end
  end

  def earning?
    !is_expense
  end

  def expense?
    is_expense
  end

end
