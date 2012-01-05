require "action_mailer"
require "active_support"
require "nestful"

module Mailgun
  class DeliveryError < StandardError
  end

  class DeliveryMethod
    attr_accessor :settings

    def initialize(settings)
      self.settings = settings
    end

    def api_host
      settings[:api_host]
    end

    def api_key
      settings[:api_key]
    end
    
    def endpoint
      "https://api:#{api_key}@api.mailgun.net/v2/#{api_host}/messages.mime"
    end

    def deliver!(mail)
      Nestful.post(
        endpoint,
        format: :multipart,
        params: {
          to: mail.destinations.join(","),
          message: mail.to_s
        }
      )
    end
  end
end

ActionMailer::Base.add_delivery_method :mailgun, Mailgun::DeliveryMethod