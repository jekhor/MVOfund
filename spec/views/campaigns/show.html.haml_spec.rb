require 'rails_helper'

RSpec.describe "campaigns/show", type: :view do
  before(:each) do
    @campaign = assign(:campaign, Campaign.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
