# frozen_string_literal: true

require 'dotenv'
require 'telegram/bot'
require 'pry-byebug'
require 'concurrent'
require_relative 'coinbase_client'

class Bot
  USERNAME = 'TelecoinCryptoBot'

  def initialize
    token = Dotenv.load['TELEGRAM_TOKEN']

    Telegram::Bot::Client.run(token, logger: Logger.new($stdout)) do |bot|
      @bot = bot
      bot.listen do |message|
        case message.text.downcase
        when '/start'
          bot.api.send_message(chat_id: message.chat.id, text: 'Welcome to an Altered Future...')
        when 'nonagon infinity'
          bot.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new('img/nonagon_stu.jpg', 'image/jpeg'))
        when 'crypto'
          bot.api.send_message(chat_id: message.chat.id, text: 'Which one?', reply_markup: crypto_currencies_keyboard)
        when 'check eos'
          timer_task = Concurrent::TimerTask.new(execution_interval: 600) do |task|
            price = coinbase.current_price(crypto: 'EOS')
            bot.logger.info("EOS Price Check:\t #{price[:amount]}")

            if price[:amount].to_f >= 4.33
              @bot.api.send_message(chat_id: message.chat.id, text: "Price of EOS is now #{price[:amount]}!")
              task.shutdown
            end
          end
          timer_task.execute
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
      .new(keyboard: CoinbaseClient::COMMON_CRYPTOS.map(&:upcase), one_time_keyboard: true)
  end

  def current_price(crypto)
    price = coinbase.current_price(crypto: crypto)
    return "There was an error trying to fetch #{crypto}-#{coinbase.currency}" if price[:error]

    "Crypto: #{price[:base]} \nValue: #{price[:amount].to_f} #{coinbase.currency}"
  end
end
