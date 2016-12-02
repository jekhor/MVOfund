json.extract! budget_item, :id, :campaign, :title, :amount, :created_at, :updated_at
json.url budget_item_url(budget_item, format: :json)