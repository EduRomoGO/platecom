ActionMailer::Base.smtp_settings = {
  address: 'smtp.mandrillapp.com',
  port: 587,
  enable_starttls_auto: true,
  user_name: 'eduromogo@outlook.com',
  password: 'lniiToRdZCC7UxVT-sO4gw',
  authentication: 'login'
}

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default charset: 'utf-8'