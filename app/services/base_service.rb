class BaseService

  def initialize(current_user=nil)
    @current_user = current_user
  end

  def current_user
    @current_user
  end

end