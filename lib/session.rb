require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @session = {}
    cookie = req.cookies['_rails_lite_app']
    if cookie
      cookie_val = JSON.parse(cookie)
      cookie_val.each do |key, val|
        self[key] = val
      end
    else
      cookie_val = {}
    end
  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    @session[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie(
      '_rails_lite_app',
      {
        path: '/',
        value: @session.to_json
      }
    )
  end
end
