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
        else
          bot.api.send_message(chat_id: message.chat.id, text: "I'm working on it, #{message.from.first_name}")
        end
      end
    end
  end
end
