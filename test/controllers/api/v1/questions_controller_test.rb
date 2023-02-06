require "test_helper"

class Api::V1::QuestionsControllerTest < ActionDispatch::IntegrationTest
  test "create action" do
    post "/api/v1/questions", params: { question: { question: "Who is John Galt?", context: "I am a giant Ayn Rand accolyte and must know her vital truths."} }
    assert_response :ok
    assert_equal({ answer: "This is the stock answer to a question, don't expect variety here." }.to_json, @response.body)
  end

  test "returns the answer to a cached question" do
    post "/api/v1/questions", params: { question: { question: "Who is John Galt?", context: "I am a giant Ayn Rand accolyte and must know her vital truths."} }
    assert_response :ok
    post "/api/v1/questions", params: { question: { question: "Who is John Galt?", context: "I am a giant Ayn Rand accolyte and must know her vital truths."} }
    assert_equal({ answer: "I already answered this question 1 times." }.to_json, @response.body)
  end
end
