module CampaignsHelper
  def remain_days(campaign)
    t = (campaign.end_date - Time.now.to_date + 1).to_i
    t > 0 ? "#{t} дней осталось" : "Сбор окончен"
  end
end
