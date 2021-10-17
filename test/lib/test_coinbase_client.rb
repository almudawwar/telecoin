require 'minitest/autorun'
require_relative '../../lib/coinbase_client'

class TestCoinbaseClient < Minitest::Test
  def setup
    @coinbase = CoinbaseClient.new
  end

  def test_default_currency
    assert_equal 'EUR', CoinbaseClient::DEFAULT_CURRENCY
  end

  def test_current_price
    skip 'test this later'
  end
end
