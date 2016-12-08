class Campaign < ActiveRecord::Base
  belongs_to :title_image, class_name: "PostImage"
  has_many :payments, inverse_of: :campaign, dependent: :destroy
  has_many :budget_items, inverse_of: :campaign, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true

  def expenses_amount
    Payment.expenses_amount(self)
  end

  def earnings_amount
    res = Payment.earnings_amount(self)
    STDERR.puts res.class
    res
  end

  def expenses
    Payment.expensed(self)
  end

  def earnings
    Payment.earnings(self)
  end

  def funded
    earnings_amount
  end

  def rest
    earnings_amount - expenses_amount
  end
end
