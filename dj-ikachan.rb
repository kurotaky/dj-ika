# -*- coding: utf-8 -*-
require 'cinch'
require 'string-irc'
require 'itunes-search-api'

config = YAML.load_file("config.yml")

class HelloPlugin
  include Cinch::Plugin

  timer 60 * 10, method: :say_hello
  def say_hello
    say_hey = StringIrc.new('YO YO')
    Channel([config["channel"]]).notice say_hey.red
  end
end

bot = Cinch::Bot.new do
  configure do |c|
    c.nick            = "DJ_IKA"
    c.server          = config["hostname"]
    c.channels        = [config["channel"]]
    c.plugins.plugins = [HelloPlugin]
    c.ssl.use         = true
    c.port            = config["port"]
    c.password        = config["password"]
  end

  on :message, /ビートルズ/ do |m|
    num = rand(100)
    itunes = ITunesSearchAPI.search(:term => "Beatles", :country => "US", :media => "music")
    m.reply "YO YO, #{m.user.nick}さん #{itunes[num]["artistName"]} の #{itunes[num]["trackName"]}  #{itunes[num]["previewUrl"]} がオススメでス"
  end
end

bot.start
