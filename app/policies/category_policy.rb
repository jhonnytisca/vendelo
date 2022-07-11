class CategoryPolicy < BasePolicy
  def method_missing(symbol, *args)
    Current.user.admin?
  end
end