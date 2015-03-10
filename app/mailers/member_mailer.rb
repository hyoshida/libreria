class MemberMailer < ApplicationMailer
  def requests(organization, member)
    @organization = organization
    @member = member
    mail to: @organization.email, subject: 'Requests to join your organization!'
  end

  def accept(organization, member)
    @organization = organization
    @member = member
    mail to: @member.email, subject: 'Accept your request!'
  end
end
