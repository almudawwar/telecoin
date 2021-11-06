# frozen_string_literal: true

require 'dotenv'
require 'telegram/bot'
require 'pry-byebug'
require_relative 'coinbase_client'

class Bot
  USERNAME = 'TelecoinCryptoBot'

  def initialize
    puts "Heyyuup - #{Process.pid}"
    token = Dotenv.load['TELEGRAM_TOKEN']

    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        case message.text.downcase
        when '/start'
          bot.api.send_message(chat_id: message.chat.id, text: 'Welcome to an Altered Future...')
        when 'nonagon infinity'
          bot.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new('img/nonagon_stu.jpg', 'image/jpeg'))
        when 'crypto'
          bot.api.send_message(chat_id: message.chat.id, text: 'Which one?', reply_markup: crypto_currencies_keyboard)
        when *CoinbaseClient::COMMON_CRYPTOS
          bot.api.send_message(chat_id: message.chat.id, text: current_price(message))
        else
          bot.api.send_message(chat_id: message.chat.id, text: "I'm a 5 star bot, #{message.from.first_name}!")
        end
      end
    end
  end

  private

  def coinbase
    @coinbase ||= CoinbaseClient.new
  end

  def crypto_currencies_keyboard
    Telegram::Bot::Types::ReplyKeyboardMarkup
      .new(keyboard: CoinbaseClient::COMMON_CRYPTOS, one_time_keyboard: true)
  end

  def current_price(crypto)
    coinbase.current_price(crypto: crypto).to_s
  end
end
