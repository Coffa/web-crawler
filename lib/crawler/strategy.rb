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

			def configure(options=nil)
        if block_given?
          yield default_options
        else
          default_options.merge!(options)
        end
      end

			def priority
				Crawler::STRATEGIES.include?(default_options[:priority]) ? default_options[:priority] : :medium
			end

			def get(url)
				curl = Crawler::Curl.new(url)
				curl.perform
				curl
			end

			def screenshot(url)
				"http://pagepeeker.com/thumbs.php?size=l&code=980d29fd93&url=#{url}"
			end

			def check(curl); end

			def parse(curl); end

			def behavior(curl); end

			def forward_link(curl, url)
				if forward? curl
					curl.instance = url
					curl.parser = self
					curl.perform
				else
					raise ManyForwardError
				end
				raise StopFlowError
			end

			def string_to_i(str)
				str.gsub(/[^\d]/, '').to_i
			end

			private
			def forward?(curl)
				number_of_forward = curl.instance_variable_get(:@number_of_forward).to_i
				number_of_forward += 1
				curl.instance_variable_set(:@number_of_forward, number_of_forward)
				(@MAX_FORWARD || 3) > number_of_forward
			end
		end

		module InstanceMethods
		end
	end
end
