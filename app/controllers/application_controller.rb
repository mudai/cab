class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActionController::RoutingError,
    ActiveRecord::RecordNotFound, with: :render_404

  private

  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404: #{exception.message}"
    end

    render file: "#{Rails.root}/public/404", status: 404, layout: false
  end

  def i18n(key, options = {})
    scope = self.class.to_s.underscore.gsub(/_|\//,".")
    options.merge!(scope: scope)
    I18n.t(key, options)
  end
end
