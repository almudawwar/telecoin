require 'minitest/autorun'
require_relative '../../lib/coinbase'

class TestCoinbase < Minitest::Test
  def setup
    @coinbase = Coinbase.new
  end

  def test_available_currencies
    assert_equal ['BTC'], Coinbase::AVAILABLE_CURRENCIES
  end

  def test_default_base
    assert_equal 'EUR', Coinbase::DEFAULT_BASE
  end

  def test_current_prices
    skip 'test this later'
  end
end
