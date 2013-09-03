module Crawler
	class Async
		def initialize(opts=nil)
			@multi_curl = ::Curl::Multi.new
			Crawler.set_config(@multi_curl, opts || Crawler.config.curl_multi)
		end

		def add_entry(url, opts=nil)
			curl = url.instance_of?(Crawler::Curl) ? url : Crawler::Curl.new(url, opts)
			curl.async = self
			@multi_curl.add(curl.instance)
		end

		def perform
			@multi_curl.perform
		end

		def configurate
			yield instance
		end

		def instance
			@multi_curl
		end
	end
end
