require 'test_helper'
require './lib/base_encoder'

class BaseEncoderTest < ActiveSupport::TestCase
  test 'encodes the number correctly for a given charset' do
    # Represents base 10
    charset = ('0'..'9').to_a

    assert_equal('0', BaseEncoder.encode(0, charset))
    assert_equal('1', BaseEncoder.encode(1, charset))
    assert_equal('10', BaseEncoder.encode(10, charset))
    assert_equal('19', BaseEncoder.encode(19, charset))
    assert_equal('21', BaseEncoder.encode(21, charset))
    assert_equal('42', BaseEncoder.encode(42, charset))
    assert_equal('99', BaseEncoder.encode(99, charset))
    assert_equal('999', BaseEncoder.encode(999, charset))

    # Represents base36
    charset = ('0'..'9').to_a + ('a'..'z').to_a
    assert_equal(0.to_s(36), BaseEncoder.encode(0, charset))
    assert_equal(1.to_s(36), BaseEncoder.encode(1, charset))
    assert_equal(10.to_s(36), BaseEncoder.encode(10, charset))
    assert_equal(19.to_s(36), BaseEncoder.encode(19, charset))
    assert_equal(21.to_s(36), BaseEncoder.encode(21, charset))
    assert_equal(42.to_s(36), BaseEncoder.encode(42, charset))
    assert_equal(99.to_s(36), BaseEncoder.encode(99, charset))
    assert_equal(999.to_s(36), BaseEncoder.encode(999, charset))
  end

  test 'it raises if the number argument is not an positive Integer' do
    assert_raises(BaseEncoder::EncodeError) { BaseEncoder.encode('foo', []) }
    assert_raises(BaseEncoder::EncodeError) { BaseEncoder.encode(-1, []) }
  end

  test 'it raises if the charset is not an Array with values' do
    assert_raises(BaseEncoder::EncodeError) { BaseEncoder.encode(1, []) }
    assert_raises(BaseEncoder::EncodeError) { BaseEncoder.encode(1, nil) }
  end

  test 'decodes the number for a given charset' do
    # Represents base 10
    charset = ('0'..'9').to_a
    assert_equal(0, BaseEncoder.decode('0', charset))
    assert_equal(1, BaseEncoder.decode('1', charset))
    assert_equal(10, BaseEncoder.decode('10', charset))
    assert_equal(19, BaseEncoder.decode('19', charset))
    assert_equal(21, BaseEncoder.decode('21', charset))
    assert_equal(42, BaseEncoder.decode('42', charset))
    assert_equal(99, BaseEncoder.decode('99', charset))
    assert_equal(999, BaseEncoder.decode('999', charset))

    # Represents base36
    charset = ('0'..'9').to_a + ('a'..'z').to_a
    assert_equal(0, BaseEncoder.decode(0.to_s(36), charset))
    assert_equal(1, BaseEncoder.decode(1.to_s(36), charset))
    assert_equal(10, BaseEncoder.decode(10.to_s(36), charset))
    assert_equal(19, BaseEncoder.decode(19.to_s(36), charset))
    assert_equal(21, BaseEncoder.decode(21.to_s(36), charset))
    assert_equal(36, BaseEncoder.decode(36.to_s(36), charset))
    assert_equal(42, BaseEncoder.decode(42.to_s(36), charset))
    assert_equal(99, BaseEncoder.decode(99.to_s(36), charset))
    assert_equal(999, BaseEncoder.decode(999.to_s(36), charset))
  end
end
