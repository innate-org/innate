class AddAverageRatingToFreecourses < ActiveRecord::Migration[7.0]
  def change
    add_column :freecourses, :average_rating, :decimal
  end
end
