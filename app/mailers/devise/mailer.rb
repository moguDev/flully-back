class Devise::Mailer < ApplicationMailer
  def reset_password_instructions(record, token, opts={})
    @token = token
    @resource = record
    @reset_password_url = "https://flully.jp/reset_password?reset_password_token=#{token}"

    mail(to: record.email, subject: 'Password Reset Instructions')
  end
end