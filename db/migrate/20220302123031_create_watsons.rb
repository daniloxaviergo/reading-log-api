class CreateWatsons < ActiveRecord::Migration[6.1]
  def change
    create_table :watsons do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.integer :minutes
      t.string :external_id

      t.belongs_to :log, index: true, null: true
      t.belongs_to :project, index: true, null: true
      t.timestamps
    end
  end
end
