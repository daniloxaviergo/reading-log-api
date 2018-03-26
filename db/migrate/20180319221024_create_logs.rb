class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.belongs_to :project, index: true
      t.datetime :data
      t.integer :start_page
      t.integer :end_page
      t.integer :wday
      t.text :note, :text

      t.timestamps
    end
  end
end
