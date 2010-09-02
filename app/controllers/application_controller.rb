# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  include AuthenticatedSystem
  
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  def access_denied
    render :template => 'shared/denied.html', :status => 401
    return false
  end

  def authorized?(action, resource=nil)
    if resource and resource.is_a? Class
      resource.user_authorized_for? current_user, {:action => action}, binding
    elsif resource.is_a? Course
      resource.user_authorized_for? current_user, action
    else
      self.class.user_authorized_for? current_user, {:action => action}, binding
    end
  end
  
  private

  def mimetype(label)
    case label.downcase
    when 'pdf' then 'application/pdf'
    when 'ppt' then 'application/vnd.ms-powerpoint'
    else 'application/octet-stream'
    end
  end

end
