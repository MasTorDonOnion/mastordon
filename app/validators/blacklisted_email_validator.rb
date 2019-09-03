# frozen_string_literal: true

class BlacklistedEmailValidator < ActiveModel::Validator
  def validate(user)
    return if user.valid_invitation?

    @email = user.email

    user.errors.add(:email, I18n.t('users.invalid_email')) if blocked_email?
  end

  private

  def blocked_email?
    on_blacklist? || not_on_whitelist?
  end

  def on_blacklist?
    return true  if EmailDomainBlock.block?(@email)
    return false if Rails.configuration.x.email_domains_blacklist.blank?

  end

  def not_on_whitelist?
    return false if Rails.configuration.x.email_domains_whitelist.blank?

  end
end
