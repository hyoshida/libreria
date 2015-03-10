class MemberMailer < ApplicationMailer
  def requests(organization, member)
    @organization = organization
    @member = member
    mail to: @organization.email, subject: 'Requests to join your organization!'
  end
end
