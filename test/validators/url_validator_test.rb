require 'test_helper'
require './app/validators/url_validator'

class UrlValidatorTest < ActiveSupport::TestCase
  test 'returns false when the url is not valid' do
    assert_not(UrlValidator.valid?('something'))
    assert_not(UrlValidator.valid?('this@is.email'))
  end

  test 'returns true when the URL is valid' do
    assert(UrlValidator.valid?('https://juntin.app/foo?bar=test'))
    assert(UrlValidator.valid?('http://other.app/'))
  end
end
