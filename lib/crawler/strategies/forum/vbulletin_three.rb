module Crawler
	module Strategies
		class VBulletinThree < Forum
			class << self
				def check(curl)
					generator = curl.html.at_css('meta[name=generator]') || return
					!!generator['content'].index(' 3.') && !!curl.html.at_css('div#posts')
				end

				def parse(curl)
					node_first = curl.html.at_css('table[id^=post]:first')
					node_last = curl.html.at_css('table[id^=post]:last')
					super(curl, node_first, node_last)
				end

				def poster(curl, node)
					last_poster(curl, node)
				end

				def time(curl, node)
					last_time(curl, node)
				end

				def content(curl, node)
					node.at_css('div[id^=post_message_]').to_html
				end

				def last_poster(curl, node)
					node.at_css('a.bigusername').text
				end

				def last_time(curl, node)
					time = node.at_css('td.thead > div:nth-of-type(2)').text
					Chronic.parse time
				end

				def counter(curl, node)
					node.at_css('td.thead a:first').text.gsub('#', '').to_i
				end

				def navigation(curl, type)
					tag_nav = curl.html.at_css('div.pagenav table') || return
					if type == :first && tag_nav.at_css('td span').text != "1"
						url = tag_nav.at_css('a:not([rel=prev])')['href']
					elsif type == :last && !!tag_nav.at_css('a[rel=next]')
						url = tag_nav.css('a.smallfont:not([rel=next])').last['href']
					end
					forward_link(curl, generate_from_href(curl, url)) if url.present? && curl.url != url
				end
			end
		end
	end
end

Crawler.add_strategy(Crawler::Strategies::VBulletinThree)
