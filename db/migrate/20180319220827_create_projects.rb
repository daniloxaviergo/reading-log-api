class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :total_page, default: 0
      t.date :started_at
      t.integer :page, default: 0
      t.boolean :reinicia, default: false
    end
  end
end
