class RemoveColumnApiUserOnIncomingRequests < ActiveRecord::Migration[7.0]
  def change
    remove_column :incoming_requests, :api_user_id
    add_reference :incoming_requests, :external_app, foreign_key: true, null: false
  end
end
