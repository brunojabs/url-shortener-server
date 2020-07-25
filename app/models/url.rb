require './lib/base_encoder'
require './app/validators/url_validator'

class Url < ApplicationRecord
  validates :target, presence: true
  validate :target_url_validation

  SLUG_CHARSET = %w(0 1 2 3 4 5 6 7 8 9
                    a b c d e f g h i j k l m n o p q r s t u v w x y z
                    A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
                    )

  def slug
    BaseEncoder.encode(id, SLUG_CHARSET)
  end

  def self.find_by_slug(slug)
    self.find(BaseEncoder.decode(slug, SLUG_CHARSET))
  end

  private

  def target_url_validation
    return if UrlValidator.valid?(target)

    errors.add(:target, :invalid)
  end
end
