module Chargify
  class Base < ActiveResource::Base
    self.format = :xml

    def self.element_name
      name.split(/::/).last.underscore
    end

    def self.site
      Thread.current['chargify_api_ares.site']
    end

    def self.site=(site)
      Thread.current['chargify_api_ares.connection'] = nil
      if site.nil?
        Thread.current['chargify_api_ares.site'] = nil
      else
        Thread.current['chargify_api_ares.site'] = create_site_uri_from site
        Thread.current['chargify_api_ares.user'] = URI.parser.unescape(Thread.current['chargify_api_ares.site'].user) if Thread.current['chargify_api_ares.site'].user
        Thread.current['chargify_api_ares.password'] = URI.parser.unescape(Thread.current['chargify_api_ares.site'].password) if Thread.current['chargify_api_ares.site'].password
      end
    end

    def self.user
      Thread.current['chargify_api_ares.user']
    end

    def self.user=(user)
      Thread.current['chargify_api_ares.connection'] = nil
      Thread.current['chargify_api_ares.user'] = user
    end

    def self.connection(refresh = false)
      Thread.current['chargify_api_ares.connection'] = ActiveResource::Connection.new(site, format) if refresh || Thread.current['chargify_api_ares.connection'].nil?
      Thread.current['chargify_api_ares.connection'].proxy = proxy if proxy
      Thread.current['chargify_api_ares.connection'].user = user if user
      Thread.current['chargify_api_ares.connection'].password = password if password
      Thread.current['chargify_api_ares.connection'].auth_type = auth_type if auth_type
      Thread.current['chargify_api_ares.connection'].timeout = timeout if timeout
      Thread.current['chargify_api_ares.connection'].ssl_options = ssl_options if ssl_options
      Thread.current['chargify_api_ares.connection']
    end

    def to_xml(options = {})
      options.merge!(:dasherize => false)
      super
    end
  end
end
