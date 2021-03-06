module Api::V2
  class Admin::AdminController < BaseApiController
    include ::Admin::ResponseWithJson

    before_action :authorize_admin!
    before_action :service

    private

    def authorize_admin!
      authenticate_request!

      raise Pundit::NotAuthorizedError unless current_user.has_role?(:admin)
    end

    def service
      service ||= "Admin::#{controller_name.singularize.capitalize}Service".constantize
      @service ||= service.new(current_user, controller_name, action_name)
    end
  end
end
