class Transfer
  
  attr_reader :sender, :receiver, :amount
  attr_accessor :status

  @@all = []

  def initialize(sender, receiver, amount)
    @sender = sender
    @receiver = receiver
    @status = "pending"
    @amount = amount
    @@all << self
  end

  def self.all
    @@all
  end

  def valid?
    # find BankAccount instances for sender and receiver in transfer
    sender = BankAccount.all.find {|acct| acct == self.sender}
    receiver = BankAccount.all.find {|acct| acct == self.receiver}
    # BankAccount.valid? on both sender and receiver
    sender.valid? && receiver.valid?
  end

  def execute_transaction
    if self.valid? && self.status == "pending" && @sender.balance >= @amount
      @sender.balance -= @amount
      @receiver.balance += @amount
      @status = "complete"
    else
      @status = "rejected"
      "Transaction rejected. Please check your account balance."
    end
  end

  def reverse_transfer
    if self.status == "complete"
      @sender.balance += @amount
      @receiver.balance -= @amount
      @status = "reversed"
    end
  end

end