# frozen_string_literal: true

require 'dotenv'
require 'telegram/bot'

class Bot
  USERNAME = 'TelecoinCryptoBot'

  def initialize
    token = Dotenv.load['TELEGRAM_TOKEN']

    Telegram::Bot::Client.run(token, logger: Logger.new($stdout)) do |bot|
      bot.listen do |message|
        MessageResponder.new(bot: bot, message: message).respond
      end
    end
  end
end
