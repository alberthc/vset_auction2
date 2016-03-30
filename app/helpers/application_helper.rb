module ApplicationHelper

  #Returns the full title on a per-page basis
  def full_title(page_title)
    base_title = "VSET Auction"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  # abs or /abs -> http://myx.com/abs
  # http://grosser.it/2008/11/24/rails-transform-path-to-url
  def path_to_url(path)
    "#{request.protocol}#{request.host_with_port.sub(/:80$/,"")}/#{path.sub}"
  end

  def cache_fetch(cache_key, expire_time, fetch_from_disk)
    Rails.cache.fetch(cache_key, expires_in: expire_time) do
      fetch_from_disk.call
    end
  end

end
