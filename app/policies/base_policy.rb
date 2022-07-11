class BasePolicy

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def method_missing(symbol, *args)
    false
  end
end