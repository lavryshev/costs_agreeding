class ChangeColumnNameWebhookUrlOnExternalApps < ActiveRecord::Migration[7.0]
  def change
    rename_column :external_apps, :webhook_url, :callback_url
  end
end
