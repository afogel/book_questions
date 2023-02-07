require 'modules/decrees/extract_tokens_from_pages'
require 'modules/decrees/create_embeddings_from_pages'

task :pdf_to_pages_embeddings => :environment do
  path = "public/models-of-situated-action.pdf"
  puts "Beginning extraction of tokens and text from PDF"
  pages_df = Decrees::ExtractTokensFromPages.new(path: path).call
  puts "Complete"
  puts "Beginning embeddings"
  Decrees::CreateEmbeddingsFromPages.new(pages_df: pages_df, path: path).call
  puts "Completed"
end