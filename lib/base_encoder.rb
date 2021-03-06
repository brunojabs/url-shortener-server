class BaseEncoder
  class EncodeError < ArgumentError;end
  class DecodeError < ArgumentError;end

  def self.encode(number, charset)
    unless number.is_a?(Integer) && number >=0
      raise EncodeError, "Only positive integers numbers are allowed to encode"
    end

    unless charset.is_a?(Array) && !charset.empty?
      raise EncodeError, "The charset must be an non-empty Array"
    end

    charset_length = charset.length

    if number < charset_length
      return charset[number]
    else
      return encode(number / charset_length, charset) + encode(number % charset_length, charset)
    end
  end

  def self.decode(number, charset)
    raise DecodeError, "The number should be a String" unless number.is_a?(String)

    unless charset.is_a?(Array) && !charset.empty?
      raise DecodeError, "The charset must be an non-empty Array"
    end

    number.split('').reverse.each_with_index.reduce(0) do |acc, (char, index)|
      acc += charset.index(char) * (charset.length ** index)
    end
  end
end
