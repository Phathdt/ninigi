class DishPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return restaurant.dishes if have_policy?
      restaurant.dishes.where(is_public: true)
    end
  end

  def create?
    record.restaurant.owner == user ||
      record.restaurant.managers.where(id: user).exists?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def toggle_active?
    create?
  end

  def toggle_public?
    create?
  end
end