require 'spec_helper'

describe Crawler::Configuration do
	it 'is a hash of default configuration' do
		expect(Crawler::Configuration.defaults).to be_kind_of(Hash)
	end

	it 'is callable from .configure' do
		Crawler.configure do |c|
			expect(c).to be_kind_of(Crawler::Configuration)
		end
	end

	it 'is able to set value' do
		Crawler.configure do |c|
			c.curl_easy[:follow_location] = false
		end
		expect(Crawler.config.curl_easy[:follow_location]).to eq(false)
	end
end
