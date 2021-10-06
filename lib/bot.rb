# frozen_string_literal: true

require 'dotenv'
require 'telegram/bot'
require 'pry-byebug'

class Bot
  USERNAME = 'TelecoinCryptoBot'

  def initialize
    puts "Heyyuup - #{Process.pid}"
    token = Dotenv.load['TELEGRAM_TOKEN']

    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        case message.text
        when '/start'
          bot.api.send_message(chat_id: message.chat.id, text: 'Welcome to an Altered Future...')
        when 'Nonagon Infinity'
          bot.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new('img/nonagon_stu.jpg', 'image/jpeg'))
        else
          bot.api.send_message(chat_id: message.chat.id, text: "I'm a 5 star bot, #{message.from.first_name}!")
        end
      end
    end
  end

  private

  def crypto_currencies_keyboard
    # This should get the available currencies from lib/coinbase
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: %w[Wooo], one_time_keyboard: true)
  end
end
