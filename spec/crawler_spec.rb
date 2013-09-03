require "spec_helper"

describe Crawler do
	describe '.strategies' do
		it 'increases when a new strategy is made' do
			expect {
				class Example
					include Crawler::Strategy
				end
			}.to change(Crawler.strategies, :size).by(1)
		end
	end

	describe '.add_strategy' do
		before(:each) do
		 	Crawler.add_strategy(Module, :low)
		 	Crawler.add_strategy(Class, :medium)
		 	Crawler.add_strategy(Object, :low)
		end

		let(:strategies) { Crawler.strategies }
		specify { expect(strategies).to have_key(:low) }
		specify { expect(strategies).to have_key(:medium) }
		specify { expect(strategies).to have_value([Module, Object]) }
		specify { expect(strategies).to have_value([Class]) }
	end

	describe '.get' do

	end
end
