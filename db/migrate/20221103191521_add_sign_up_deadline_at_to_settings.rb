class AddSignUpDeadlineAtToSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :sign_up_deadline_at, :datetime
  end
end
