require 'rails_helper'

RSpec.describe "budget_items/edit", type: :view do
  before(:each) do
    @budget_item = assign(:budget_item, BudgetItem.create!(
      :campaign => "MyString",
      :title => "MyString",
      :amount => "9.99"
    ))
  end

  it "renders the edit budget_item form" do
    render

    assert_select "form[action=?][method=?]", budget_item_path(@budget_item), "post" do

      assert_select "input#budget_item_campaign[name=?]", "budget_item[campaign]"

      assert_select "input#budget_item_title[name=?]", "budget_item[title]"

      assert_select "input#budget_item_amount[name=?]", "budget_item[amount]"
    end
  end
end
