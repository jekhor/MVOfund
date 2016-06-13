require 'rails_helper'

RSpec.describe "campaigns/index", type: :view do
   let(:valid_attributes) {
     [
    {
      title: "First Campaign",
      description: "Campaign description"
    },
    {
      title: "Second Campaign",
      description: "Campaign description second"
    },
     ]
  }

 before(:each) do
    assign(:campaigns, [
      Campaign.create!(valid_attributes[0]),
      Campaign.create!(valid_attributes[1])
    ])
  end

  it "renders a list of campaigns" do
    render
  end
end
