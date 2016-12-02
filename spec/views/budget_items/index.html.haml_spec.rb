require 'rails_helper'

RSpec.describe "budget_items/index", type: :view do
  before(:each) do
    assign(:budget_items, [
      BudgetItem.create!(
        :campaign => "Campaign",
        :title => "Title",
        :amount => "9.99"
      ),
      BudgetItem.create!(
        :campaign => "Campaign",
        :title => "Title",
        :amount => "9.99"
      )
    ])
  end

  it "renders a list of budget_items" do
    render
    assert_select "tr>td", :text => "Campaign".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
