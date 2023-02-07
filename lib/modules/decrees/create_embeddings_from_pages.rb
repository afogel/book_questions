require "ruby/openai"

module Decrees
  class CreateEmbeddingsFromPages
    attr_reader :client, :pages_df, :filename
    MODEL_NAME = "curie"
    DOC_EMBEDDINGS_MODEL = "text-search-#{MODEL_NAME}-doc-001"

    def initialize(pages_df:, path:)
      @client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:OPENAI_API_KEY))
      @pages_df = pages_df
      @filename = Pathname.new(path).basename.to_s.split(".").first
    end

    def call
      puts "Creating embeddings"
      document_embeddings = @pages_df.rows.map.with_index do |page, index|
        title = page[0]
        content = page[1]
        puts "Generating embeddings for #{title}"
        # get the embeddings for the document
        embeddings = client.embeddings(parameters: {model: DOC_EMBEDDINGS_MODEL, input: content})["data"][0]["embedding"]
        puts "Adding page #{index}"
        # create a page with the title and embeddings
        Page.create(title: title, embedding: embeddings)
      end
    end
  end
end
