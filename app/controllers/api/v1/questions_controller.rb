class Api::V1::QuestionsController < ApplicationController
  def create
    if true
      render json: { answer: "I know the answer to what you're asking, but I ain't telling..." }, status: :ok
    else
      render json: { errors: question.errors.full_messages }, status: 422
    end
  end

  def question_params
    params.require(:question).permit(:question, :context)
  end
end
