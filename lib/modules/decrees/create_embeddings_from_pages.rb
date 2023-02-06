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
        if index < 3
          title = page[0]
          content = page[1]
          puts "Generating embeddings for #{title}"
          # get the embeddings for the document
          embeddings = client.embeddings(parameters: {model: DOC_EMBEDDINGS_MODEL,input: content})["data"][0]["embedding"]
          # create a dataframe with the title and the embeddings
          df_row = embeddings.each.with_index.reduce(Polars::DataFrame.new([{title: title}])) do |memo, (value,idx)| 
            memo.hstack(Polars::DataFrame.new([{"#{idx}" => value }])) 
          end
          df_row
        else
          nil
        end
      end
      doc_embeddings = document_embeddings.compact.reduce(Polars::DataFrame.new) do |memo, df|
        memo.vstack(df)
      end
      debugger
        puts "Writing embeddings to CSV"
        doc_embeddings.write_csv("#{filename}.embeddings.csv")
      File.open("#{filename}.embeddings.csv", 'w') do |f|
        writer = CSV.new(f)
        writer << ["title"] + (0..4095).to_a
        doc_embeddings.each_with_index do |embedding, i|
          writer << ["Page #{i + 1}"] + embedding
        end
      end
      puts "Complete"
    end
  end
end