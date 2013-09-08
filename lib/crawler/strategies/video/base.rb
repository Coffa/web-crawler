module Crawler
	module Strategies
		class Video
			include Crawler::Strategy

			option :priority, :medium

			class << self
				def parse(curl, identify)
					begin
						navigation(curl, identify)
						extract(curl)
					rescue StopFlowError
					end
				end

				def navigation(curl, identify)
					unless curl.url =~ identify
						get_info_first_link curl
						forward_link(curl, api_link(curl))
					end
				end

				def get_info_first_link(curl); end
			end
		end
	end
end
