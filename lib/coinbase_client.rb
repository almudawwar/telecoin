# frozen_string_literal: true

require 'coinbase/wallet'
require 'dotenv'

class CoinbaseClient
  DEFAULT_CURRENCY = 'EUR'
  COMMON_CRYPTOS = %w[btc eth dot sol icp ltc eos cgld].freeze

  attr_accessor :currency

  def initialize(currency: DEFAULT_CURRENCY)
    @currency = currency
    @client = Coinbase::Wallet::Client.new(api_key: Dotenv.load['COINBASE_KEY'],
                                           api_secret: Dotenv.load['COINBASE_SECRET'])
  end

  def current_price(crypto: 'BTC')
    return {} if crypto.nil?

    price = fetch_price(crypto)
    return { error: :invalid_currency } if price.nil?

    price.transform_keys(&:to_sym)
  end

  private

  def currency_pair(crypto)
    "#{crypto}-#{@currency}"
  end

  def fetch_price(crypto)
    @client.spot_price({ currency_pair: currency_pair(crypto) })
  rescue Coinbase::Wallet::NotFoundError
    nil
  end
end
