require 'rails_helper'

RSpec.describe "campaigns/edit", type: :view do
  let(:valid_attributes) {
    {
      title: "First Campaign",
      description: "Campaign description"
    }
  }

  before(:each) do
    @campaign = assign(:campaign, Campaign.create!(valid_attributes))
  end

  it "renders the edit campaign form" do
    render

    assert_select "form[action=?][method=?]", campaign_path(@campaign), "post" do
    end
  end
end
