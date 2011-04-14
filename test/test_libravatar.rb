require 'helper'

class TestLibravatar < Test::Unit::TestCase
  should "Generate url" do
    # echo -n "user@example.com"|shasum -a 256
    # => b4c9a289323b21a01c3e940f150eb9b8c542587f1abfd8f0e1cc1ffc5e475514
    avatar = Libravatar.new(:email => "user@example.com")
    assert_equal avatar.to_s, "http://cdn.libravatar.org/avatar/b4c9a289323b21a01c3e940f150eb9b8c542587f1abfd8f0e1cc1ffc5e475514"
  end

  should "Normalize OpenID" do
    assert_equal Libravatar.normalize_openid("HTTP://EXAMPLE.COM/id/Bob"), "http://example.com/id/Bob"
  end
end
