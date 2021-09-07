class SandboxEmailInterceptor
  def self.delivering_email(message)
    if Rails.env.demo?
      message.to = ['demo-mailer@mavillemonshopping.fr']
      message.bcc = ['demo-mailer@mavillemonshopping.fr']
    else
      message.to = ['mail.preprod@mavillemonshopping.fr']
      message.bcc = ['mail.preprod@mavillemonshopping.fr']
    end
  end
end
if !Rails.env.production?
  ActionMailer::Base.register_interceptor(SandboxEmailInterceptor)
end