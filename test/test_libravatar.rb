require 'helper'

class TestLibravatar < Test::Unit::TestCase
  should "Generate url from email" do
    # echo -n "user@example.com"|md5sum
    # => b58996c504c5638798eb6b511e6f49af
    avatar = Libravatar.new(:email => "user@example.com")
    assert_equal avatar.to_s, "http://cdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af"

    assert_equal Libravatar.new(:email => "USER@ExAmPlE.CoM").to_s, "http://cdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af"

    assert_equal Libravatar.new(:email => "user@example.com", :https => true).to_s, "https://seccdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af"

    assert_equal Libravatar.new(:email => "user@example.com", :https => false).to_s, "http://cdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af"

    assert_equal Libravatar.new(:email => "USER@ExAmPlE.CoM", :default => "http://example.com/avatar.png").to_s, "http://cdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af?d=http://example.com/avatar.png"

    assert_equal Libravatar.new(:email => "USER@ExAmPlE.CoM", :size => 512, :default => "mm").to_s, "http://cdn.libravatar.org/avatar/b58996c504c5638798eb6b511e6f49af?s=512&d=mm"
  end

  should "Generate url from openid" do
    # echo -n "http://example.com/id/Bob"|shasum -a 256
    # => 80cd0679bb52beac4d5d388c163016dbc5d3f30c262a4f539564236ca9d49ccd
    avatar = Libravatar.new(:openid => "http://example.com/id/Bob")
    assert_equal avatar.to_s, "http://cdn.libravatar.org/avatar/80cd0679bb52beac4d5d388c163016dbc5d3f30c262a4f539564236ca9d49ccd"

    avatar = Libravatar.new(:openid => "hTTp://EXAMPLE.COM/id/Bob")
    assert_equal avatar.to_s, "http://cdn.libravatar.org/avatar/80cd0679bb52beac4d5d388c163016dbc5d3f30c262a4f539564236ca9d49ccd"

    avatar = Libravatar.new(:openid => "hTTp://EXAMPLE.COM/id/Bob", :size => 512)
    assert_equal avatar.to_s, "http://cdn.libravatar.org/avatar/80cd0679bb52beac4d5d388c163016dbc5d3f30c262a4f539564236ca9d49ccd?s=512"
  end

  should "Normalize OpenID" do
    x = Libravatar.new
    assert_equal x.send(:normalize_openid, "HTTP://EXAMPLE.COM/id/Bob"), "http://example.com/id/Bob"

    assert_equal x.send(:normalize_openid, "HTTP://EXAMPLE.COM"), "http://example.com/"
  end

  should "Retured the federated URI" do
    avatar = Libravatar.new(:email => 'invalid@catalyst.net.nz')
    assert_equal avatar.to_s, 'http://static.avatars.catalyst.net.nz/avatar/f924d1e9f2c10ee9efa7acdd16484c2f'
  end
end
