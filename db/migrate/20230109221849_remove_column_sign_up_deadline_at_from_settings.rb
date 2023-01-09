class RemoveColumnSignUpDeadlineAtFromSettings < ActiveRecord::Migration[7.0]
  def change
    remove_column :settings, :sign_up_deadline_at, :string
    remove_column :settings, :pickup_date_and_time, :string
    remove_column :settings, :pickup_date_and_end_time, :string
  end
end
