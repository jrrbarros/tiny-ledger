class Account
  attr_reader :id, :balance, :transactions

  def initialize(id)
    @id = id
    @balance = 0
    @transactions = []
  end

  def deposit(amount)
    raise ArgumentError, "Deposit amount must be greater than 0" if amount <= 0

    @balance += amount
    @transactions << Transaction.new(:deposit, amount)
  end

  def withdraw(amount)
    raise ArgumentError, "Withdrawal amount must be greater than 0" if amount <= 0
    raise ArgumentError, "Withdrawal amount must be up to current balance" if amount > @balance

    @balance -= amount
    @transactions << Transaction.new(:withdrawal, amount)
  end
end
