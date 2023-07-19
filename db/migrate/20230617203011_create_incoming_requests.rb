class CreateIncomingRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :incoming_requests do |t|
      t.references :api_user, null: false, foreign_key: true
      t.string :action
      t.jsonb :data, null: false, default: '{}'
    end
  end
end
