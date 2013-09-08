module Crawler
	module Strategies
		class Youtube < Video
			class << self
				def check(curl)
					!!(curl.url =~ /youtube\.com/)
				end

				def parse(curl)
					super(curl, /gdata\.youtube\.com/)
				end

				def api_link(curl)
					query = Rack::Utils.parse_query URI.parse(curl.url).query
					"https://gdata.youtube.com/feeds/api/videos/#{query['v']}?v=2&alt=json"
				end

				def extract(curl)
					info = JSON.parse(curl.body_str)['entry']
					curl.parser_data.merge!({
						:id => info['media$group']['yt$videoid']['$t'],
						:title => info['title']['$t'],
						:link => "http://www.youtube.com/watch?v=#{info['media$group']['yt$videoid']['$t']}",
						:author => info['author'][0]['name']['$t'],
						:comments => info['gd$comments']['gd$feedLink']['countHint'],
						:duration => info['media$group']['media$content'][0]['duration'],
						:description => info['media$group']['media$description']['$t'],
						:thumbnail => info['media$group']['media$thumbnail'][3]['url'],
						:publish => info['published']['$t'],
						:updated => info['updated']['$t'],
						:category => info['category'][1]['label'],
						:rate => {
							:average => info['gd$rating']['average'],
							:raters => info['gd$rating']['numRaters']
						},
						:views => {
							:counter => info['yt$statistics']['viewCount'],
							:like => info['yt$rating']['numLikes'],
							:dislike => info['yt$rating']['numDislikes']
						}
					})
				end
			end
		end
	end
end

Crawler.add_strategy(Crawler::Strategies::Youtube)
