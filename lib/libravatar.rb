#
# The Libravatar class generates the avatar URL provided by the libravatar
# web service at http://www.libravatar.org
#
# Users may associate their avatar images with multiple OpenIDs and Emails.
#  
# Author:: Kang-min Liu (http://gugod.org)
# Copyright:: Copyright (c) 2011 Kang-min Liu
# License:: MIT
# Contributors:: https://github.com/gugod/libravatar/contributors
#

require 'digest/md5'
require 'digest/sha2'
require 'uri'
require 'resolv'

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
  # - :default URL to redirect missing avatars to, or one of these specials: "404", "mm", "identicon", "monsterid", "wavatar", "retro"
  #
  def initialize(email: nil, openid: nil, size: nil, default: nil, https: nil)
    @email   = email
    @openid  = openid
    @size    = size
    @default = default
    @https   = https
  end

  # All the values which are different between HTTP and HTTPS methods.
  PROFILES = [
      {
          scheme: 'http://',
          host:   'cdn.libravatar.org',
          srv:    '_avatars._tcp.',
          port:   80,
      },
      {
          scheme: 'https://',
          host:   'seccdn.libravatar.org',
          srv:    '_avatars-sec._tcp.',
          port:   443,
      }
  ]

  # Generate the libravatar URL
  def url
    if @email
      @email.downcase!
      id = Digest::MD5.hexdigest(@email)
    else
      id = Digest::SHA2.hexdigest(normalize_openid(@openid))
    end
    s  = @size ? "s=#{@size}" : nil
    d  = @default ? "d=#{@default}" : nil

    query = [s,d].reject{|x|!x}.join('&')
    query = "?#{query}" unless query == ''
    baseurl = get_base_url + '/avatar/'

    baseurl + id + query
  end

  alias_method :to_s, :url

  private

    def get_target_domain
      if @email
        @email.split('@')[1]
      else
        URI.parse(@openid).host
      end
    end

    # Grab the DNS SRV records associated with the target domain,
    # and choose one according to RFC2782.
    def srv_lookup
      profile = PROFILES[ @https ? 1 : 0 ]
      Resolv::DNS::open do |dns|
        rrs = dns.getresources(profile[:srv] + get_target_domain,
                               Resolv::DNS::Resource::IN::SRV).to_a
        return [nil, nil] unless rrs.any?


        min_priority = rrs.map{ |r| r.priority }.min
        rrs.delete_if{ |r| r.priority != min_priority }

        weight_sum = rrs.inject(0) { |a,r| a+r.weight }.to_f

        r = rrs.max_by { |r| r.weight == 0 ? 0 : rand ** (weight_sum / r.weight) }

        return [r.target, r.port]
      end
    end

    def get_base_url
      profile = PROFILES[ @https ? 1 : 0 ]
      target, port = srv_lookup

      if target && port
        port_fragment = port != profile[:port] ? ':' + port.to_s : ''
        profile[:scheme] + target.to_s + port_fragment
      else
        profile[:scheme] + profile[:host]
      end
    end

    def sanitize_srv_lookup(hostname, port)
      unless hostname.match(/^[0-9a-zA-Z\-.]+$/) && 1 <= port && port <= 65535
        return [nil, nil]
      end

      [hostname, port]
    end

    # Normalize an openid URL following the description on libravatar.org
    def normalize_openid(s)
      x = URI.parse(s)
      x.host.downcase!
      x.scheme = x.scheme.downcase
      if x.path == '' && x.fragment == nil
        x.path = '/'
      end

      x.to_s
    end

end
