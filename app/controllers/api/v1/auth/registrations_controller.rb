module Api::V1
  class Auth::RegistrationsController < BaseApiController
    prepend_before_action :authenticate_request!, only: %i[]

    def create
      data, status = service.create(registration_params)
      render_json(data, status)
    end

    private

    def registration_params
      params.require(:users).permit(:email, :password, :password_confirmation, :name)
    end
  end
end
