class List

  attr_reader :twitter_list_id, :name, :uri, :subscriber_count, :member_count, :mode, :tracked

  def initialize(parameters)
    @twitter_list_id = parameters[:twitter_list_id]
    @name = parameters[:name]
    @uri = parameters[:uri]
    @subscriber_count = parameters[:subscriber_count]
    @member_count = parameters[:member_count]
    @mode = parameters[:mode]
    @tracked = parameters[:tracked]
  end

end
