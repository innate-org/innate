class AddUserReferenceToFreecourses < ActiveRecord::Migration[7.0]
  def change
    add_reference :freecourses, :user, null: true, foreign_key: true
    Freecourse.update_all(user_id: User.first.id)
  end
end