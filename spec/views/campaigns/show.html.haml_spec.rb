require 'rails_helper'

RSpec.describe "campaigns/show", type: :view do
  let(:valid_attributes) {
    {
      title: "First Campaign",
      description: "Campaign description"
    }
  }

  before(:each) do
    @campaign = assign(:campaign, Campaign.create!(valid_attributes))
  end

  it "renders attributes in <p>" do
    render
  end
end
