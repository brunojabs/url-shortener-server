class UrlSerializer
  def self.serialize(url)
    raise 'you must provide a Url model to serialize' unless url.is_a?(Url)

    {
      slug: url.slug,
      target: url.target,
      hits: url.hits
    }
  end
end
