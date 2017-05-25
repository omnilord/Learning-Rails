class Payment < ActiveRecord::Base
  attr_accessor :card_number, :card_cvc, :card_expires_month, :card_expires_year
  belongs_to :user

  def self.month_options
    Date::MONTHNAMES.compact.each_with_index.map { |n, i| ["#{i + 1} - #{n}", i + 1] }
  end

  def self.year_options
    (Date.today.year..(Date.today.year + 10)).to_a
  end

  def process_payment(amt=1000)
    customer = Stripe::Customer.create(email: email, source: token)
    charge = Stripe::Charge.create(
      customer: customer.id,
      description: "Premium Registration for #{email}",
      currency: 'usd',
      amount: amt
    )
  end
end
