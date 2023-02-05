require "test_helper"

class Api::V1::QuestionsControllerTest < ActionDispatch::IntegrationTest
  test "create action" do
    post "/api/v1/questions", params: { question: { question: "Who is John Galt?", context: "I am a giant Ayn Rand accolyte and must know her vital truths."} }
    assert_response :ok
    assert_equal({ answer: "I know the answer to what you're asking, but I ain't telling..." }.to_json, @response.body)
  end
end
