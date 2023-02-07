class Api::V1::QuestionsController < ApplicationController
  def create
    @question = Question.find_or_initialize_by(question_params)
    if @question.id?
      @question.ask_count += 1
      @question.answer = "I already answered this question #{@question.ask_count} times."
    else
      @question.embedding = GetQueryEmbedding.new.call(content: @question.question, model: @question)
      # Get nearest neighbors to the query embedding
      ordered_page_titles = Page.nearest_neighbors(:embedding, @question.embedding, distance: :cosine).pluck(:title)
      @question.answer = "This is the stock answer to a question, don't expect variety here."
      @question.context = "This is the stock context for a question, don't expect variety here."
      @question.ask_count = 0
    end
    if @question.save
      render json: {answer: @question.answer}, status: :ok
    else
      render json: {errors: @question.errors.full_messages}, status: 422
    end
  end

  def question_params
    params.require(:question).permit(:question)
  end
end
