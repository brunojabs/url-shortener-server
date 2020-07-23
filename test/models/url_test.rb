require 'test_helper'

class UrlTest < ActiveSupport::TestCase
  self.use_transactional_tests = true

  test "is valid with valid attributes" do
    record = Url.new(target: 'https://juntin.app')
    assert(record.valid?)

    record = Url.new(target: 'http://juntin.app')
    assert(record.valid?)

    record = Url.new(target: 'https://juntin.app?test="something"')
    assert(record.valid?)
  end

  test 'is not valid with invalid attributes' do
    record = Url.new(target: nil)
    assert(!record.valid?)

    record = Url.new(target: 'not-valid-url')
    assert(!record.valid?)
  end

  test '#slug returns the record ID represented in a base62 ([0-9][a-z][A-Z])' do
    record = Url.new(id: 1)

    assert_equal(record.slug, '1')

    record = Url.new(id: 62)
    assert_equal(record.slug, 'Z')

    record = Url.new(id: 63)
    assert_equal(record.slug, '00')
  end
end
