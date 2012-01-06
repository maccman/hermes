require 'digest/md5'
require 'cgi'

module Gravatar extend self
  DEFAULT = "http://robohash.org/%s.png?size=80x80&bgset=1"
  
  def make(email)
    return unless email
    email   = email.downcase
    hash    = Digest::MD5.hexdigest(email)
    default = CGI.escape(DEFAULT % hash)
    
    "http://www.gravatar.com/avatar/#{hash}?d=#{default}"
  end
end