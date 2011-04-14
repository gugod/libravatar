require 'digest/sha2'

class Libravatar
  attr_accessor :size, :email, :openid, :size

  def initialize(options = {})
    @email = options[:email]
  end

  def to_s
    id = Digest::SHA2.hexdigest(@email)
    return "http://cdn.libravatar.org/avatar/" + id
  end
end
