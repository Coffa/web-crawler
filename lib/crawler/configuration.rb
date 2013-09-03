require 'singleton'

module Crawler
	class Configuration
		include Singleton

		@@defaults = {
			:curl_easy => {
				:useragent => 'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.17 Safari/537.36',
				:max_redirects => 3,
				:timeout => 20,
				:autoreferer => true,
				:follow_location => true,
			},
			:curl_multi => {
				:max_connects => 1000,
			}
		}

		def initialize
			@@defaults.each_pair {|k,v | self.send("#{k}=", v)}
		end

		class << self
			def defaults
				@@defaults
			end
		end

		attr_accessor :curl_easy, :curl_multi
	end
end
