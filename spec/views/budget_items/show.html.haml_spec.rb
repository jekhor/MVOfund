require 'rails_helper'

RSpec.describe "budget_items/show", type: :view do
  before(:each) do
    @budget_item = assign(:budget_item, BudgetItem.create!(
      :campaign => "Campaign",
      :title => "Title",
      :amount => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Campaign/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/9.99/)
  end
end
