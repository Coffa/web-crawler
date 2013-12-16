require 'spec_helper'

describe Crawler::Curl do
  let(:curl) { Crawler::Curl.new 'google.com', {:timeout => 5, :follow_location => true} }
  describe '.initialize' do
  	specify { expect(curl.html.root).to be_nil }

  	context "check instance config" do
  	  subject(:instance) {curl.instance}
	    its(:url) { should eq('google.com') }
	    its(:timeout) { should eq(5) }
  	end
  end

  describe '.instance' do
    it 'has Curl::Easy type' do
      expect(curl.instance).to be_an(::Curl::Easy)
    end
  end

  describe '.instance=' do
    it 'get new instance of Curl::Easy' do
      curl.instance = 'bing.com'
      expect(curl.instance.url).to eq('bing.com')
    end

    it 'same callback' do
      expect(curl.callbacks).to have(0).items
    end
  end

  describe '.html' do
  	it 'has Nokogiri type' do
  	  expect(curl.html).to be_an(Nokogiri::HTML::Document)
  	end
  end

  describe '.url' do
    it 'forward to www.google.com' do
      curl.perform
      expect(curl.url).to start_with('http://www.google.com.vn/')
    end
  end

  describe '.callbacks=' do
    it 'raise TypeError' do
      expect {
        curl.callbacks = ["mquy"]
        }.to raise_error(TypeError)
    end

    it 'set one callback' do
      class C
        def x; end
      end
      callbacks = [C.new.method(:x)]
      curl.callbacks = callbacks
      expect(curl.callbacks).to eq(callbacks)
    end
  end

  describe '.parser=' do
    it 'raise TypeError' do
      expect {
        curl.parser = '121'
      }.to raise_error(TypeError)
    end

    it 'set ExampleStrategy parser' do
      curl.parser = ExampleStrategy
      expect(curl.parser).to eq(ExampleStrategy)
    end
  end

  describe '.async' do
    it 'should be an instance of Crawler::Async' do
      expect(curl.async).to be_an(Crawler::Async)
    end
  end

  context 'state: perform' do

  end
end
