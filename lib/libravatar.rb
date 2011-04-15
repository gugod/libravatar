#
# The Libravatar class generates the avatar URL provided by the libravatar
# web service at http://www.libravatar.org
#
# Users may associate their avatar images with multiple OpenIDs and Emails.
#  
# Author:: Kang-min Liu (http://gugod.org)
# Copyright:: Copyright (c) 2011 Kang-min Liu
# License:: MIT
#

require 'digest/sha2'
require 'uri'

class Libravatar
  attr_accessor :size, :email, :openid, :size

  # Normalize an openid URL following the description on libravatar.org
  def self.normalize_openid(s)
    x = URI.parse(s)
    x.host.downcase!
    x.scheme = x.scheme.downcase
    if (x.path == "" && x.fragment == nil)
      x.path = "/"
    end
    return x.to_s
  end

  # The options should contain :email or :openid values.  If both are
  # given, email will be used. The value of openid and email will be
  # normalized by the rule described in http://www.libravatar.org/api
  def initialize(options = {})
    @email  = options[:email]
    @openid = options[:openid]
    @size   = options[:size]
  end

  # Generate the libravatar URL
  def to_s
    id = Digest::SHA2.hexdigest(@email || self.class.normalize_openid(@openid))
    return "http://cdn.libravatar.org/avatar/" + id
  end
end
