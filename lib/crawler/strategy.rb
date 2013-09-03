module Crawler
	module Strategy
		def self.included(base)
			base.extend         ClassMethods
			base.send :include, InstanceMethods
		end

		module ClassMethods
			def default_options
				return @default_options if instance_variable_defined?(:@default_options) && @default_options
				@default_options = superclass.respond_to?(:default_options) ? superclass.default_options : {}
			end

			def option(name, value=nil)
				default_options[name] = value
			end

			def priority
				Crawler::STRATEGIES.include?(default_options[:priority]) ? default_options[:priority] : :medium
			end

			def get(url)
				curl = Crawler::Curl.new(url)
				curl.perform
				parse(curl)
			end

			def screenshot(url)
				"http://pagepeeker.com/thumbs.php?size=l&code=980d29fd93&url=#{url}"
			end

			def check(curl); end

			def parse(curl); end

			def behavior(curl); end
		end

		module InstanceMethods
		end
	end
end
