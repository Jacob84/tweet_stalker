require 'rubygems'
require 'json'

class TwitterListAnalyzer
  def initialize(url_analyzer = EntityUrlIdentifier.new, http_client = HttpClient.new)
    @url_analyzer = url_analyzer
    @http = http_client
  end

  def process_pending_tweets
    pendings = Tweet.where(analyzed: false)

    pendings.each do |t|
      process_tweet(t)
    end

    false
  end

  private

  def process_tweet(tweet)
    urls_to_analyze = []

    tweet.urls.split('|').each do |e|
      urls_to_analyze << e if @url_analyzer.should_be_analyzed?(e)
    end

    json_response = call_service(tweet, urls_to_analyze)
    noun_phrases = build_noun_phrases(json_response)
    save_analyzed_tweet(tweet, noun_phrases)
  end

  def save_analyzed_tweet(tweet, noun_phrases)
    tweet.noun_phrases = noun_phrases.join('|')
    tweet.analyzed = true
    tweet.save
  end

  def call_service(tweet, urls_to_analyze)
    message = { tweet_text: tweet.text, entities: urls_to_analyze }.to_json
    ctype = { 'Content-Type' => 'application/json' }
    response = @http.get(message, ctype)

    JSON.parse(response.body)
  end

  def build_noun_phrases(json_response)
    noun_phrases = []

    json_response['result'].each do |r|
      noun_phrases << "#{r[0]}:#{r[1]}"
    end

    noun_phrases
  end

end
