module Crawler
	module Strategies
		class Vimeo < Video
			class << self
				def check(curl)
					!!(curl.url =~ /vimeo\.com/)
				end

				def parse(curl)
					super(curl, /vimeo\.com\/api\/v2\/video/)
				end

				def api_link(curl)
					query = URI.parse(curl.url).path
					"http://vimeo.com/api/v2/video/#{query.gsub('/', '')}.json"
				end

				def extract(curl)
					info = JSON.parse(curl.body_str).first
					curl.parser_data.merge!({
						:id => info['id'],
						:title => info['title'],
						:link => info['url'],
						:author => info['user_name'],
						:duration => info['duration'],
						:description => info['description'],
						:thumbnail => info['thumbnail_large'],
						:publish => info['upload_date']
					})
				end

				def get_info_first_link(curl)
					tag_cols = curl.html.at_css('#cols')
					comments = tag_cols.at_css('meta[content^=UserComments]')['content']
					likes = tag_cols.at_css('meta[content^=UserLikes]')['content']
					plays = tag_cols.at_css('meta[content^=UserPlays]')['content']
					curl.parser_data.merge!({
						:comments => string_to_i(comments),
						:likes => string_to_i(likes),
						:plays => string_to_i(plays)
					})
				end
			end
		end
	end
end

Crawler.add_strategy(Crawler::Strategies::Vimeo)
