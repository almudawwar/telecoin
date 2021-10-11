# frozen_string_literal: true

require 'dotenv'

class Coinbase
  AVAILABLE_CURRENCIES = %w[BTC].freeze
  DEFAULT_BASE = 'EUR'

  def initialize(base: DEFAULT_BASE)
    @base = base
  end

  def current_prices
    {}
  end
end
