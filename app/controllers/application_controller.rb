# frozen_string_literal: true

class ApplicationController < ActionController::Base
	before_action :store_browser_info
  
  private

  def store_browser_info
    RequestStore.store[:browser] = Browser.new(request.user_agent)
  end
end
