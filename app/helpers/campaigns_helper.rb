module CampaignsHelper
  def remain_days(campaign)
    t = (campaign.end_date - Time.now.to_date + 1).to_i
    t > 0 ? t : 0
  end

  def fraction_to_percent_with_limit(frac, options)
    number_to_percentage(frac > 1 ? 100 : frac * 100, options)
  end
end
