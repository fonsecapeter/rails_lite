require 'json'

class Flash
  attr_reader :now
  def initialize(req)
    @flash = {}
    cookie = req.cookies['_rails_lite_app_flash']
    if cookie
      cookie_val = JSON.parse(cookie)
      cookie_val.each do |key, val|
        self[key] = val
      end
    else
      cookie_val = {}
    end
    @now = FlashNow.new(cookie_val)
  end

  def [](key)
    @flash[key] || @now[key]
  end

  def []=(key, val)
    @flash[key] = val
  end

  def store_flash(res)
    res.set_cookie(
      '_rails_lite_app_flash',
      { path: '/',
        value: @flash.to_json
      }
    )
  end
end

class FlashNow
  def initialize(cookie = {})
    @flash = cookie
  end

  def [](key)
    @flash[key]
  end

  def []=(key, val)
    @flash[key] = val
  end
end
