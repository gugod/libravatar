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

require 'digest/md5'
require 'digest/sha2'
require 'uri'

class Libravatar
  attr_accessor :email, :openid, :size, :default, :https

  # The options should contain :email or :openid values.  If both are
  # given, email will be used. The value of openid and email will be
  # normalized by the rule described in http://www.libravatar.org/api
  #
  # List of option keys:
  #
  # - :email
  # - :openid
  # - :size An integer ranged 1 - 512, default is 80.
  # - :https Set to true to serve avatars over SSL
  # - :default URL (or special value) to redirect missing avatars to
  #
  def initialize(options = {})
    @email   = options[:email]
    @openid  = options[:openid]
    @size    = options[:size]
    @default = options[:default]
    @https   = options[:https]
  end

  # Generate the libravatar URL
  def to_s
    if @email
      @email.downcase!
      id = Digest::MD5.hexdigest(@email)
    else
      id = Digest::SHA2.hexdigest(normalize_openid(@openid))
    end
    s  = @size ? "s=#{@size}" : nil
    d  = @default ? "d=#{@default}" : nil

    query = [s,d].reject{|x|!x}.join("&")
    query = "?#{query}" unless query == ""
    baseurl = @https ? "https://seccdn.libravatar.org/avatar/" : "http://cdn.libravatar.org/avatar/"
    return baseurl + id + query
  end

  private

  # Normalize an openid URL following the description on libravatar.org
  def normalize_openid(s)
    x = URI.parse(s)
    x.host.downcase!
    x.scheme = x.scheme.downcase
    if (x.path == "" && x.fragment == nil)
      x.path = "/"
    end
    return x.to_s
  end
end
