module Crawler
	module Strategies
		class Forum
			include Crawler::Strategy

			MAX_FORWARD = 3

			option :prority, :low

			class << self
				def behavior(curl, behavior=:update)
					curl.parser = self
					curl.behavior = behavior
				end

				def base_url(curl)
					base = curl.html.at_css('head base')
					if base.present?
						base['href']
					else
						uri = URI.parse(curl.url)
						"#{uri.scheme}://#{uri.host}/"
					end
				end

				def generate_from_href(curl, url)
					url.start_with?('http') ? url : base_url(curl) + url
				end

				def forward_link(curl, url)
					if forward? curl
						curl.instance = url
						curl.parser = self
						curl.async.add_entry(curl)
						curl.async.perform
					end
					raise StopFlowError
				end

				def get_info_first_link(curl, node=nil)
					navigation_first(curl)
					curl.parser_data.merge!({
						:root_link => curl.url,
						:screenshot => screenshot(curl.url),
						:title => title(curl),
						:poster => poster(curl, node),
						:time => time(curl, node),
						:content => content(curl, node)
					})
				end

				def get_info_last_link(curl, node=nil)
					curl.parser_data.merge!({
						:last_link => curl.url,
						:last_poster => last_poster(curl, node),
						:last_time => last_time(curl, node),
						:counter => counter(curl, node)
					})
				end

				def title(curl)
					curl.html.at_css('head title').text
				end

				def content(curl, node); end
				def last_time(curl, node); end
				def counter(curl, node); end
				def last_poster(curl, node); end
				def poster(curl, node); end
				def time(curl, node); end

				def method_missing(name, *args, &block)
					if /navigation_(?<type>.+)/ =~ name.to_s
						args.push(type.to_sym)
						self.navigation(*args)
					else
						super(name, *args, &block)
					end
				end

				private
				def forward?(curl)
					number_of_forward = curl.instance_variable_get(:@number_of_forward).to_i
					number_of_forward += 1
					curl.instance_variable_set(:@number_of_forward, number_of_forward)
					MAX_FORWARD > number_of_forward
				end
			end
		end
	end
end
