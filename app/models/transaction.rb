class Transaction
  attr_reader :type, :amount, :timestamp

  def initialize(type, amount)
    @type = type
    @amount = amount
    @timestamp = Time.current
  end
end
