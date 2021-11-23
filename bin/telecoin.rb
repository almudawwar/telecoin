# frozen_string_literal: true

require 'dotenv'
require 'telegram/bot'
require_relative '../lib/message_responder'

Dotenv.load

# USERNAME = 'TelecoinCryptoBot'
Telegram::Bot::Client.run(ENV['TELEGRAM_TOKEN'], logger: Logger.new($stdout)) do |bot|
  bot.listen do |message|
    MessageResponder.new(bot: bot, message: message).respond
  end
end
