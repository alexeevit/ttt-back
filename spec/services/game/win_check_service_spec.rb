require 'rails_helper'

describe Game::WinCheckService do
  describe '#check' do
    subject(:handler) { described_class.new }

    it 'determines win on a row and returns player num' do
      cell = 0
      state = [0,   0,   0,
               nil, 1,   1,
               1,   nil, nil]

      expect(handler.send(:check, state, cell)).to eq(0)
    end

    it 'determines win on a column and returns player num' do
      cell = 0
      state = [1,   0,   0,
               1,   0,   nil,
               1,   nil, nil]

      expect(handler.send(:check, state, cell)).to eq(1)
    end

    it 'determines win on a diagonal 1 and returns player num' do
      cell = 4
      state = [1,   0,   0,
               1,   1,   nil,
               0,   nil, 1]

      expect(handler.send(:check, state, cell)).to eq(1)
    end

    it 'determines win on a diagonal 2 and returns player num' do
      cell = 4
      state = [nil, 1,   0,
               1,   0,   1,
               0,   nil, nil]

      expect(handler.send(:check, state, cell)).to eq(0)
    end

    it 'determines if there is no win' do
      cell = 4
      state = [nil, 1,   1,
               1,   0,   1,
               0,   0, nil]

      expect(handler.send(:check, state, cell)).to be_nil
    end
  end
end
