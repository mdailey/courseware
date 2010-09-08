class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = SITE_PREFIX + "/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = SITE_PREFIX
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = ADMIN_EMAIL
      @subject     = "[COURSEWARE] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
