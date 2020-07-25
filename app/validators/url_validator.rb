class UrlValidator
  def self.valid?(url)
    URI::regexp(%w(http https)).match?(url)
  end
end
