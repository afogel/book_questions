class Api::V1::QuestionsController < ApplicationController
  def show
    @question = Question.find(Question.pluck(:id).sample)
    if @question
      render json: {question: @question.question, answer: @question.answer}, status: :ok
    else
      render json: {error: "No questions found"}, status: 404
    end
  end

  def create
    @question = Question.find_or_initialize_by(question_params)
    if @question.id?
      @question.ask_count += 1
    else
      @question.embedding = GetQueryEmbedding.new.call(content: @question.question, model: @question)
      # Get nearest neighbors to the query embedding
      ordered_page_titles = Page.nearest_neighbors(:embedding, @question.embedding, distance: :cosine).pluck(:title)
      answer, context = GetQueryAnswer.new.call(query: @question.question, ordered_page_titles: ordered_page_titles)
      puts "Answer: #{answer}"
      @question.answer = answer
      puts "Context: #{context}"
      @question.context = context
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
