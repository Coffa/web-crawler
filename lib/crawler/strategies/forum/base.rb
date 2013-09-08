module Crawler
	module Strategies
		class Forum
			include Crawler::Strategy

			option :priority, :low

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

				def parse(curl, node_first, node_last)
					begin
						get_info_first_link(curl, node_first) unless curl.behavior == :update || curl.parser_data.present?
						navigation_last(curl)
						get_info_last_link(curl, node_last)
					rescue StopFlowError
						return
					end
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
			end
		end
	end
end
