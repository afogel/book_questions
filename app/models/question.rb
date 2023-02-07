class Question < ApplicationRecord
  validates_presence_of :question, :answer, :context
  validates_uniqueness_of :question

  has_neighbors :embedding
end
