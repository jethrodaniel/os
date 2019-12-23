def bin_to_hex bin
  bin.chars.map.with_index do |c|
    if c
  end
  bin.chars.each do |c|

  end
end

require "minitest/autorun"

describe 'bin_to_hex' do
  it 'do' do
    _(bin_to_hex("1110")).must_equal "1110".to_i(2).to_s(16)
  end
end
