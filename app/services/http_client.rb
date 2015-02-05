class HttpClient
  include HTTParty

  def get(message, content_type)

    response = self.class.get("http://127.0.0.1:5000",
      :body => message,
      :headers => content_type,
      :timeout => 360)

      return response
  end
end
