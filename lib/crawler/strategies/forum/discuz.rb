module Crawler
	module Strategies
		class Discuz < Forum
			class << self
				def check(curl)
					!!curl.html.at_css('body#nv_forum')
				end

				def parse(curl)
					tag_posts = curl.html.at_css('div#postlist')
					node_first = tag_posts.at_css('> div[id^=post_]:first')
					node_last = tag_posts.at_css('> div[id^=post_]').last
					super(curl, node_first, node_last)
				end

				def poster(curl, node)
					last_poster(curl, node)
				end

				def time(curl, node)
					last_time(curl, node)
				end

				def content(curl, node)
					node.at_css('td[id^=postmessage_]').to_html
				end

				def last_poster(curl, node)
					node.at_css('div.authi > a').text
				end

				def last_time(curl, node)
					time = node.at_css('em[id^=authorposton]')
					if !!time.at_css('span')
						Chronic.parse time['title']
					else
						Chronic.parse time.text.gsub(/[^\d\-: ]/, '').strip
					end
				end

				def counter(curl, node)
					node.at_css('a[id^=postnum]').text.gsub('#', '').to_i
				end

				def navigation(curl, type)
					tag_nav = curl.html.at_css('div#pgt div.pg:first') || return
					if type == :first && tag_nav.at_css('strong').text != "1"
						url = tag_nav.at_css('> a:not([class=prev])')['href']
					elsif type == :last && tag_nav.at_css(':last').name.downcase != 'strong'
						url = tag_nav.at_css('> a:nth-last-of-type(2)')['href']
					end
					forward_link(curl, generate_from_href(curl, url)) if url.present? && curl.url != url
				end
			end
		end
	end
end

Crawler.add_strategy(Crawler::Strategies::Discuz)
