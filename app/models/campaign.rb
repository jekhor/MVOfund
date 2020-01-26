class Campaign < ActiveRecord::Base
  belongs_to :title_image, class_name: "PostImage"
  has_many :payments, inverse_of: :campaign, dependent: :destroy
  has_many :budget_items, inverse_of: :campaign, dependent: :destroy
  has_many :checkouts, inverse_of: :campaign, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :campaign_number, presence: true
  validates :campaign_number, uniqueness: true

  def expenses_amount
    Payment.expenses_amount(self)
  end

  def earnings_amount
    Payment.earnings_amount(self)
  end

  def expenses
    Payment.expenses(self)
  end

  def earnings
    Payment.earnings(self)
  end

  def budget_expenses_amount
    BudgetItem.expenses_amount(self)
  end

  def budget_earnings_amount
    BudgetItem.earnings_amount(self)
  end

  def budget_expenses
    BudgetItem.expenses(self)
  end

  def budget_earnings
    BudgetItem.earnings(self)
  end


  def funded
    earnings_amount
  end

  def spent
    expenses_amount
  end

  def rest
    earnings_amount - expenses_amount
  end
end
