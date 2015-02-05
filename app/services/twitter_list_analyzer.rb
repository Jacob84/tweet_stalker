require "rubygems"
require "json"

class TwitterListAnalyzer

  def initialize(url_analyzer = EntityUrlIdentifier.new, http_client = HttpClient.new)
    @url_analyzer = url_analyzer
    @http = http_client
  end

  def process_pending_tweets
    pendings = Tweet.where(:analyzed => false)

    pendings.each do |t|
      urls_to_analyze = []

      t.urls.split('|').each do |e|
        if @url_analyzer.should_be_analyzed?(e)
          urls_to_analyze << e
        end
      end

      message = { :tweet_text => t.text, :entities => urls_to_analyze }.to_json
      ctype = { 'Content-Type' => 'application/json' }
      response = @http.get(message, ctype)
      json_response = JSON.parse(response.body)

      noun_phrases = []

      json_response['result'].each do |r|
        noun_phrases << "#{r[0]}:#{r[1]}"
      end

      t.noun_phrases = noun_phrases.join('|')
      t.analyzed = true
      t.save
    end

    return false
  end

end
