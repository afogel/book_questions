require "tokenizers"
require "pdf-reader"

module Decrees
  class ExtractTokensFromPages
    attr_reader :reader, :tokenizer, :filename

    def initialize(path:)
      @reader = PDF::Reader.new(path)
      @filename = Pathname.new(path).basename.to_s.split(".").first
      @tokenizer = Tokenizers.from_pretrained("gpt2")
    end

    def call
      pages_df = reader.pages.map.with_index do |page, index|
        extract_pages(page.text, index)
      end.compact.reduce(Polars::DataFrame.new) do |memo, df|
        memo.vstack(df)
      end
      puts "Writing to CSV"
      pages_df.write_csv("#{filename}.pages.csv")
      pages_df
    end

    private

    def count_tokens(text)
      tokenizer.encode(text, add_special_tokens: false).tokens.length
    end

    def extract_pages(page_text, index)
      return if page_text.length == 0
      content = page_text.split(" ").join(" ")
      magic_number = 4
      Polars::DataFrame.new([{
        title: "Page #{index}",
        content: content,
        tokens: count_tokens(content) + magic_number
      }])
    end
  end
end
