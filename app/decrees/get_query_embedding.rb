require "ruby/openai"

class GetQueryEmbedding
  attr_reader :client, :query_embeddings_model

  def initialize(model_name: "curie")
    @query_embeddings_model = "text-search-#{model_name}-query-001"
    @client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:OPENAI_API_KEY))
  end

  def call(content:, model:)
    puts "Creating embeddings for #{model.class.name}: #{content}"
    client.embeddings(parameters: {model: query_embeddings_model, input: content})["data"][0]["embedding"]
  end
end
