# EntityUrlEnumeration
module EntityUrlEnumeration
  TWITTER = 1
  YOUTUBE = 2
  OTHER = 9999
end

# EntityUrlIdentifier
class EntityUrlIdentifier

  def should_be_analyzed?(entity_url)
    case get_type(entity_url)
    when  EntityUrlEnumeration::TWITTER,  EntityUrlEnumeration::YOUTUBE
      return false
    end

    return true
  end

  def get_type(entity_url)
    if entity_url.include? "https://twitter.com"
      return EntityUrlEnumeration::TWITTER
    end

    if entity_url.include? "https://www.youtube.com"
      return EntityUrlEnumeration::YOUTUBE
    end

    return EntityUrlEnumeration::OTHER
  end

end
