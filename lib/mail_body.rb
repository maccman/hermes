module MailBody extend self
  def strip(body)
    return if body.blank?
    body = body.split(/^-----Original Message-----/, 2)[0]
    body = body.split(/^________________________________/, 2)[0]
    body = body.split(/^On .+ wrote:(\n|\r\n)/, 2)[0]
    body = body.split(/^---? ?(\n|\r\n)/, 2)[0]
    
    return if body.blank?      
    body.gsub!(/Sent from my i?Phone/i, "")
    body.gsub!(/Sent from my BlackBerry/i, "")
    body.strip!
    body
  end
end