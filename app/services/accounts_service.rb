class AccountsService
  @accounts = {
    "dummy" => Account.new("dummy")
  }

  class << self
    def balance(id)
      get_account(id).balance
    end

    def deposit(id, amount)
      get_account(id).deposit(amount)
    end

    def withdraw(id, amount)
      get_account(id).withdraw(amount)
    end

    def transactions(id)
      get_account(id).transactions.map do |transaction|
        {
          type: transaction.type,
          amount: transaction.amount,
          timestamp: transaction.timestamp
        }
      end
    end

    private

    def get_account(id)
      # This is ready to be extended to a collection of accounts indexed by their ids, change this when needed
      # Also, we can raise an error for non-existing accounts
      @accounts["dummy"]
    end
  end
end
