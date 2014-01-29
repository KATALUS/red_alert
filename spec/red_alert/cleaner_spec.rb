require 'spec_helper'

describe RedAlert::Cleaner do
  let(:filter_keys) { ['foo', 'bar'] }

  subject { RedAlert::Cleaner.new(filter_keys) }

  it 'filters keys from a hash' do
    result = subject.scrub('foo' => 'secret', 'baz' => 'cool')
    result['foo'].must_equal RedAlert::Cleaner::FILTERED_TEXT
    result['baz'].must_equal 'cool'
  end

  it 'returns a new hash' do
    input = {'qux' => 'val'}
    subject.scrub(input).wont_be_same_as input
  end

  it 'filters nested hashes' do
    input = {'zing' => {'foo' => 'secret'}}
    result = subject.scrub(input)
    result['zing']['foo'].must_equal RedAlert::Cleaner::FILTERED_TEXT
  end

  it 'stringifys with unserializable data' do
    bad_data = lambda { puts 'hello' }
    input = {'zing' => bad_data}
    result = subject.scrub(input)
    assert_equal result['zing'], bad_data.to_s
  end

  it 'stringifys with unserializable data in arrays' do
    bad_data = lambda { puts 'hello' }
    input = {'zing' => [bad_data]}
    result = subject.scrub(input)
    assert_equal result['zing'].first, bad_data.to_s
  end

  it 'stringifys ints' do
    input = {'zing' => 1}
    result = subject.scrub(input)
    result['zing'].must_equal '1'
  end

  it 'handles recursive arrays' do
    a = []
    a << a
    input = {'zing' => a}
    result = subject.scrub(input)
    result['zing'].first.must_equal RedAlert::Cleaner::RECURSIVE_TEXT
  end

  it 'handles recursive hashes' do
    input = {}
    input['zing'] = {'self' => input}
    result = subject.scrub(input)
    result['zing']['self'].must_equal RedAlert::Cleaner::RECURSIVE_TEXT
  end

  it 'handles nil' do
    input = {'zing' => nil}
    result = subject.scrub(input)
    result['zing'].must_equal nil
  end
end
