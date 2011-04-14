require 'digest/sha2'
require 'uri'

class Libravatar
  attr_accessor :size, :email, :openid, :size

  def self.normalize_openid(s)
    x = URI.parse(s)
    x.host.downcase!
    x.scheme = x.scheme.downcase
    if (x.path == "" && x.fragment == nil)
      x.path = "/"
    end
    return x.to_s
  end

  def initialize(options = {})
    @email = options[:email]
    @openid = options[:openid]
  end

  def to_s
    id = Digest::SHA2.hexdigest(@email || self.class.normalize_openid(@openid))
    return "http://cdn.libravatar.org/avatar/" + id
  end
end
