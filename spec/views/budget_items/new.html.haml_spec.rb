require 'rails_helper'

RSpec.describe "budget_items/new", type: :view do
  before(:each) do
    assign(:budget_item, BudgetItem.new(
      :campaign => "MyString",
      :title => "MyString",
      :amount => "9.99"
    ))
  end

  it "renders new budget_item form" do
    render

    assert_select "form[action=?][method=?]", budget_items_path, "post" do

      assert_select "input#budget_item_campaign[name=?]", "budget_item[campaign]"

      assert_select "input#budget_item_title[name=?]", "budget_item[title]"

      assert_select "input#budget_item_amount[name=?]", "budget_item[amount]"
    end
  end
end
