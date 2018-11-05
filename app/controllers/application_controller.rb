class ApplicationController < ActionController::Base
    
    protect_from_forgery with: :null_session

    before_action :set_locale
    
    def renderJson(type, opts = {})
        case type
        when :created
          render json: opts, root: false, status: type
        when :unprocessable
          render json: opts, status: :unprocessable_entity
        when :no_content
          head type
        when :unauthorized
          if opts[:errors].nil?
            opts[:errors] = []
            opts[:errors].push("Acceso Denegado")
          end
          render json: opts, status: type
        when :not_found
          if opts[:errors].nil?
            opts[:errors] = []
            opts[:errors].push("not found")
          end
          render json: opts, status: type
        else
          render json: opts, status: type
        end
    end
    
    private

    def set_locale
        I18n.locale = params[:locale] || I18n.default_locale
    end

    def default_url_options(options = {})
        {locale: I18n.locale}.merge options
    end
end
