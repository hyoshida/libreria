class MemberMailer < ApplicationMailer
  def requests(organization, member)
    @organization = organization
    @member = member
    mail to: @organization.email, subject: t('member_mailer.requests.subject')
  end

  def accept(organization, member)
    @organization = organization
    @member = member
    mail to: @member.email, subject: t('member_mailer.accept.subject')
  end
end
