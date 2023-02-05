require 'modules/decrees/extract_tokens_from_pages'

task :pdf_to_pages_embeddings => :environment do
  path = "public/hpmor-1.pdf"
  puts "Beginning extraction of tokens and text from PDF"
  page_df = Decrees::ExtractTokensFromPages.new(path: path).call
  puts "Complete"
end