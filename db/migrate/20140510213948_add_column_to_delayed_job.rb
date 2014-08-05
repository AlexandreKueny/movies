class AddColumnToDelayedJob < ActiveRecord::Migration
  def change
    add_column :delayed_jobs, :job_process_status, :integer, :default => 0
  end
end
