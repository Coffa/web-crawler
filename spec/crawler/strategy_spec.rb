require "spec_helper"

describe Crawler::Strategy do
  describe '.default_options' do
  	it 'is inherited from a parent class' do
  		ExampleStrategy.configure do |c|
  			c[:priority] = :top
  		end

  		kclass = Class.new(ExampleStrategy)
  		expect(kclass.default_options[:priority]).to eq(:top)
  	end
  end

  describe '.configure' do
    it 'when block is passed' do
      ExampleStrategy.configure do |c|
        c[:priority] = :bottom
      end
      expect(ExampleStrategy.default_options[:priority]).to eq(:bottom)
    end

    it 'when params is passed' do
      ExampleStrategy.configure :priority => :bottom
      expect(ExampleStrategy.default_options[:priority]).to eq(:bottom)
    end
  end

  describe '.option' do
    it 'set a default value' do
      ExampleStrategy.option :priority, :aloha
      expect(ExampleStrategy.default_options[:priority]).to eq(:aloha)
    end
  end

  describe '.priority' do
    specify { expect(ExampleStrategy.priority).to eq(:medium) }

    it 'use by setter value' do
      ExampleStrategy.option :priority, :low
      expect(ExampleStrategy.priority).to eq(:low)
    end
  end

  describe '.string_to_i' do
    specify { expect(ExampleStrategy.string_to_i('12xcv0')).to eq(120) }
    specify { expect(ExampleStrategy.string_to_i('~?@#$#@$')).to eq(0) }
  end

  describe '.get' do
    it 'finish with status success' do
      curl = ExampleStrategy.get('https://www.google.com.vn/')
      expect(curl.status).to eq('success')
    end
  end

  describe '.forward_link' do
    let(:curl) { curl = Crawler::Curl.new 'http://www.bing.com/' }
    it 'redirect to new link' do
      expect {
        ExampleStrategy.forward_link(curl, 'https://www.google.com.vn/')
      }.to raise_error(Crawler::StopFlowError)
    end

    it 'exceed the number of forawrd' do
      ExampleStrategy.instance_variable_set(:@MAX_FORWARD, 0)
      expect {
        ExampleStrategy.forward_link(curl, 'https://www.google.com.vn/')
      }.to raise_error(Crawler::ManyForwardError)
    end
  end
end
