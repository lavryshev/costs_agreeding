class ChangeColumnNullActionOnIncomingRequests < ActiveRecord::Migration[7.0]
  def change
    change_column_null :incoming_requests, :action, false
  end
end
