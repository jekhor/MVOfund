require "rails_helper"

RSpec.describe BudgetItemsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/budget_items").to route_to("budget_items#index")
    end

    it "routes to #new" do
      expect(:get => "/budget_items/new").to route_to("budget_items#new")
    end

    it "routes to #show" do
      expect(:get => "/budget_items/1").to route_to("budget_items#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/budget_items/1/edit").to route_to("budget_items#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/budget_items").to route_to("budget_items#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/budget_items/1").to route_to("budget_items#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/budget_items/1").to route_to("budget_items#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/budget_items/1").to route_to("budget_items#destroy", :id => "1")
    end

  end
end
