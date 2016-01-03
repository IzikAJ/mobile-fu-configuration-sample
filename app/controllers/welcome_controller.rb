class WelcomeController < ApplicationController
  caches_page :index
  caches_action :contacts, :layout => false, cache_path: :url_cache.to_proc

  def index
  end

  def contacts
  end
end
