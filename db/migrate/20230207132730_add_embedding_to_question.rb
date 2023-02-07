class AddEmbeddingToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :embedding, :vector
  end
end
