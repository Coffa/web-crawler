module Crawler
	module Strategies
		class VBulletinFour < Forum
			class << self
				def check(curl)
					generator = curl.html.at_css('meta[name=generator]') || return
					!!generator['content'].index(' 4.') && !!curl.html.at_css('ol#posts')
				end

				def parse(curl)
					node_first = curl.html.at_css('li[id^=post_]:first')
					node_last = curl.html.at_css('li[id^=post_]:last')
					super(curl, node_first, node_last)
				end

				def title(curl)
					curl.html.at_css('title').text
				end

				def poster(curl, node)
					last_poster(curl, node)
				end

				def time(curl, node)
					last_time(curl, node)
				end

				def content(curl, node)
					node.at_css('blockquote.postcontent').to_html
				end

				def last_poster(curl, node)
					node.at_css('a.username').text
				end

				def last_time(curl, node)
					time = node.at_css('span.date').text
					Chronic.parse time
				end

				def counter(curl, node)
					node.at_css('a.postcounter').text.gsub('#', '').to_i
				end

				def navigation(curl, type)
					tag_nav = curl.html.at_css('div#pagination_top > form.pagination') || return
					if type == :first && tag_nav.at_css('span.selected').text != "1"
						url = tag_nav.at_css('a[rel=start]')['href']
					elsif type == :last && !tag_nav.at_css('span:last')['class'].include?('selected')
						url = tag_nav.at_css('> span:last a')['href']
					end
					forward_link(curl, generate_from_href(curl, url)) if url.present? && curl.url != url
				end
			end
		end
	end
end

Crawler.add_strategy(Crawler::Strategies::VBulletinFour)
