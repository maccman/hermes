# Rails 3 Config
# 
# In: config/application.yml
# 
#   development:
#     github:
#       key: test
#       secret: verysecret-dev
#   production:
#     github:
#       key: test
#       secret: verysecret-dev
# 
# Usage:
#   Rails.config.github.key
#   Rails.config.github.secret?

module Rails
  class Config < ActiveSupport::OrderedOptions
    def self.load(path = nil)
      path ||= Rails.root.join('config', 'application.yml')
      config = YAML.load(path.read)
      new(config[Rails.env.to_s] || config)
    end
    
    def initialize(options = {})
      super()
      options.each {|k, v| self[k] = v }
    end
    
    def [](key)
      value = super(key)
      value = self.class.new(value) if value.is_a?(Hash)
      value
    end
  end
  
  def self.config
    @config ||= Config.load
  end
end