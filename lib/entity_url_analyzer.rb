module EntityUrlEnumeration
  TWITTER = 1
  OTHER = 9999
end

class EntityUrlAnalyzer

  def should_be_analyzed?(entity_url)
    if get_type(entity_url) == EntityUrlEnumeration::TWITTER
      return false
    end

    return true
  end

  def get_type(entity_url)
    if entity_url.extended_url.include? "https://twitter.com"
      return EntityUrlEnumeration::TWITTER
    end

    return EntityUrlEnumeration::OTHER
  end

end
