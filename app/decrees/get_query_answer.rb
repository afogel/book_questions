require "ruby/openai"

class GetQueryAnswer
  attr_reader :client, :completions_model, :temperature, :max_tokens, :page_contents
  MAX_SECTION_LEN = 1000
  SEPARATOR = "\n* "

  def initialize(model_name: "text-davinci-003", temperature: 0.0, max_tokens: 150)
    @completions_model = model_name
    @client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:OPENAI_API_KEY))
    @page_contents = Polars.read_csv(Rails.root.join("public", "models-of-situated-action.pages.csv"))
    @max_tokens = max_tokens
    # We use temperature of 0.0 because it gives the most predictable, factual answer.
    @temperature = temperature
  end

  # @param query [String] the content to generate an embedding for
  # @param ordered_page_titles [Polars::Dataframe<Page>] the pages to use as context
  def call(query:, ordered_page_titles:)
    puts "Generating prompt using context"
    prompt, context = build_prompt(query, ordered_page_titles)
    puts "Generating answer"
    response = client.completions(
      parameters: {
        model: completions_model,
        temperature: temperature,
        max_tokens: max_tokens,
        prompt: prompt
      }
    )
    puts "Returning answer"
    begin
      return_val = response["choices"].map { |c| c["text"] }.join(" ").strip
    rescue => exception
      puts "Error: #{exception}"
    end
    [return_val, context]
  end

  private

  def build_prompt(query, ordered_page_titles)
    header = %(David Williamson Shaffer is widely-cited professor at University of Wisconsin-Madison and the
      founder of the field of Quantitative Ethnography. Please keep your answers to three sentences
      maximum, and speak in complete sentences. Stop speaking once your point is made.\n\n
      Please answer the following question: #{query}\n\n
      Here is some context that may be useful, pulled from an article in which Dr. Shaffer introduces Epistemic Frame Theory:\n
    ).strip_heredoc

    completed_prompt = header + SEPARATOR

    remaining_tokens = MAX_SECTION_LEN - completed_prompt.split(" ").length
    context = ""

    ordered_page_titles.each do |title|
      row = page_contents[Polars.col("title") == title]
      if remaining_tokens - (row["tokens"][0] + SEPARATOR.length) > 0
        remaining_tokens -= row["tokens"][0]
        completed_prompt += row["content"][0] + SEPARATOR
        context += row["content"][0] + SEPARATOR
      else
        completed_prompt += row["content"][0][0..(remaining_tokens - SEPARATOR.length)] + SEPARATOR
        context += row["content"][0][0..(remaining_tokens - SEPARATOR.length)] + SEPARATOR
        break
      end
    end

    [completed_prompt, context]
  end
end
