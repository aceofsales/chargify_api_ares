module Chargify
  class << self
    %i[subdomain api_key site format timeout domain protocol].each do |method|
      define_method method do
        Thread.current["chargify_api_ares.#{method}"]
      end

      define_method "#{method}=" do |arg|
        Thread.current["chargify_api_ares.#{method}"] = arg
      end
    end

    def configure
      # Since site is dependent on other fields, we erase it before yielding so that it is recalculated based
      # on changes from any of the other settings
      self.site = nil

      yield self

      self.protocol  = protocol  || "https"
      self.domain    = domain    || "chargify.com"
      self.format    = format    || :xml
      self.subdomain = subdomain || "test"
      self.site      = site || "#{protocol}://#{subdomain}.#{domain}"

      Base.site      = site
      Base.user      = api_key
      Base.password  = 'X'
      Base.timeout   = timeout unless (timeout.blank?)
      Base.format    = format
    end
  end
end
