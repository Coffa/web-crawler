require 'curb'
require 'nokogiri'
require 'chronic'
require 'crawler/version'

module Crawler
	STRATEGIES = [:high, :medium, :low]

	autoload :Strategy, 'crawler/strategy'
	autoload :Configuration, 'crawler/configuration.rb'
	autoload :Forum, 'crawler/strategies/forum/base'
	autoload :Video, 'crawler/strategies/video/base'

	class << self
		def strategies
			@@strategies ||= Hash[STRATEGIES.zip([[], [], []])]
		end

		def add_strategy(base, priority=nil)
			priority = base.priority if priority.blank?
			strategies[priority] << base unless strategies[priority].include? base
		end

		def get(url, opts=nil)
			curl = Crawler::Curl.new(url, opts)
			curl.perform
			curl
		end

		def parse(curl)
			strategies.values.flatten.each do |strategy|
				return strategy.parse(curl) if strategy.check(curl)
			end
		end

		def config
			Configuration.instance
		end

		def configure
			yield config
		end

		def set_config(obj, opts)
			opts.each_pair {|k, v| obj.send("#{k}=", v)}
		end
	end

	module Error
		require 'crawler/error'
	end

	module Strategies
		Dir.glob("#{File.dirname(__FILE__)}/crawler/strategies/*.rb", &method(:require))
		Dir.glob("#{File.dirname(__FILE__)}/crawler/strategies/*/*.rb", &method(:require))
	end
end
