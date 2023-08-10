class ChangeColumnNameExternalId < ActiveRecord::Migration[7.0]
  def change
    rename_column :sources, :external_id, :externalid
  end
end
