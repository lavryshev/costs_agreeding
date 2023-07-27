class ChangeColumnStatusId < ActiveRecord::Migration[7.0]
  def change
    change_column :status_changed_reports, :status, :integer
  end
end
