module Crawler
	module Strategies
		class DailyMotion < Video
			class << self
				def check(curl)
					!!(curl.url =~ /dailymotion\.com/)
				end

				def parse(curl)
					super(curl, /api\.dailymotion\.com/)
				end

				def api_link(curl)
					query = URI.parse(curl.url).path.split('/').last
					"https://api.dailymotion.com/video/#{query}?fields=comments_total,created_time,description,duration,id,rating,ratings_total,tags,thumbnail_url,title,url,views_total"
				end

				def extract(curl)
					info = JSON.parse(curl.body_str)
					curl.parser_data.merge!({
						:id => info['id'],
						:title => info['title'],
						:link => info['url'],
						:author => info['user_name'],
						:duration => info['duration'],
						:description => info['description'],
						:thumbnail => info['thumbnail_url'],
						:publish => info['created_time'],
						:comments => info['comments_total'],
						:rate => {
							:average => info['rating'],
							:raters => info['ratings_total']
						},
						:tags => info['tags'],
						:views => info['views']
					})
				end
			end
		end
	end
end

Crawler.add_strategy(Crawler::Strategies::DailyMotion)

