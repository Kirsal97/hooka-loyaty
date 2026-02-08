module Authorization
  extend ActiveSupport::Concern

  included do
    helper_method :current_admin?
  end

  private
    def current_admin?
      Current.employee&.admin?
    end

    def require_admin
      unless current_admin?
        redirect_to root_path, alert: t("authorization.not_authorized")
      end
    end
end
