class DropTableServiceTasks < ActiveRecord::Migration[7.0]
  def change
    drop_table :service_tasks
  end
end
