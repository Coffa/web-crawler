module Crawler
	module Strategies
		class Xenforo < Forum
			class << self
				def check(curl)
					!!curl.url.index('/threads/') && curl.html.root[:id] == 'XenForo'
				end

				def parse(curl)
					tag_posts = curl.html.at_css('ol#messageList:first')
					node_first = tag_posts.at_css('> li:first')
					node_last = tag_posts.at_css('> li:last')
					super(curl, node_first, node_last)
				end

				def poster(curl, node)
					last_poster(curl, node)
				end

				def time(curl, node)
					last_time(curl, node)
				end

				def content(curl, node)
					node.at_css('blockquote.messageText').to_html
				end

				def last_poster(curl, node)
					node.at_css('a.username').text
				end

				def last_time(curl, node)
					time = node.at_css('div.messageInfo > div.messageMeta > div.privateControls .DateTime')['title']
					if time.present?
						time = time.split(' ')
						Chronic.parse "#{time.first} #{time.last}"
					end
				end

				def counter(curl, node)
					node.at_css('div.messageInfo > div.messageMeta > div.publicControls').text().gsub('#', '').to_i
				end

				def navigation(curl, type)
					tag_nav = curl.html.at_css('div.PageNav > nav') || return
					if type == :first && tag_nav.at_css('a.currentPage').text != "1"
						url = tag_nav.at_css('> a[rel=start]')['href']
					elsif type == :last && !tag_nav.at_css('a:last')['class'].include?('currentPage')
						url = tag_nav.at_css('> a:nth-last-of-type(2)')['href']
					end
					forward_link(curl, generate_from_href(curl, url)) if url.present? && curl.url != url
				end
			end
		end
	end
end

Crawler.add_strategy(Crawler::Strategies::Xenforo)
