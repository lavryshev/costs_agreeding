class ChangeTableNameIncomingRequests < ActiveRecord::Migration[7.0]
  def change
    rename_table :incoming_requests, :service_tasks
  end
end
