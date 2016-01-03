class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  has_mobile_fu


  protected
    def cache_folder 
      (has_mobile_version? && is_mobile_device?) ? '/mobile' : '/desktop'
    end
      
    def cache_page(content = nil, options = nil, gzip = Zlib::BEST_COMPRESSION)
      return unless self.class.perform_caching && caching_allowed?

      path = case options
        when Hash
          url_for(options.merge(only_path: true, format: params[:format]))
        when String
          options
        else
          request.path == '/' ? 'index' : request.path
        end

      if (type = Mime::LOOKUP[self.content_type]) && (type_symbol = type.symbol).present?
        extension = ".#{type_symbol}"
      end

      path = File.join(cache_folder, path) if mobile_enabled?
      self.class.cache_page(content || response.body, path, extension, gzip)
    end

    def url_cache
      if mobile_enabled?
        "[#{(has_mobile_version? && is_mobile_device? ? 'mobile' : 'desktop')}]#{request.url}"
      else
        request.url
      end
    end
end
