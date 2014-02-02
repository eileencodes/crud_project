module ApplicationHelper
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  module BootstrapExtension
    def text_field(name, value = nil, options = {})
      class_name = options[:class]
      options[:class] = "form-control"
      super
    end

    def password_field(name, value = nil, options = {})
      class_name = options[:class]
      options[:class] = "form-control"
      super
    end

    def text_field_tag(name, value = nil, options = {})
      class_name = options[:class]
      options[:class] = "form-control"
      super
    end

    def submit_tag(name, options = {})
      class_name = options[:class]
      options[:class] = "btn pull-right btn-success submit"
      super
    end
  end

  include BootstrapExtension
end
