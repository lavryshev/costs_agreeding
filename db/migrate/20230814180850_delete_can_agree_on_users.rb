class DeleteCanAgreeOnUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :can_agree
  end
end
