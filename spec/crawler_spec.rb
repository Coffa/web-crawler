require "spec_helper"

describe Crawler do
	describe '.strategies' do
		let(:strategies) { Crawler.strategies }
		specify { expect(strategies.keys).to eq([:high, :medium, :low]) }
	end

	describe '.add_strategy' do
		before(:each) do
		 	Crawler.add_strategy(Module, :low)
		 	Crawler.add_strategy(Class, :medium)
		 	Crawler.add_strategy(Object, :low)
		end

		let(:strategies) { Crawler.strategies }
		specify { expect(strategies[:low]).to include(*[Module, Object]) }
		specify { expect(strategies[:medium]).to include(*[Class]) }
	end

	context 'configuration' do
	  it 'is a instance of Configuration' do
	  	Crawler.configure do |config|
	  		expect(config).to be_kind_of(Crawler::Configuration)
	  	end
	  end
	end

	describe '.set_config' do
		subject(:curl) do
			curl = ::Curl::Easy.new
	  	Crawler.set_config(curl, {:timeout => 20})
		end
	  its(:timeout) { should eq(20)}
	end
end
