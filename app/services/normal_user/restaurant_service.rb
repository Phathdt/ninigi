module NormalUser
  class RestaurantService < BaseService
    def index(page_number)
      restaurants = Restaurant.where(state: :publiced).page(page_number || 1)
      [restaurants, :ok]
    end
  end
end
