class CreateUnits < ActiveRecord::Migration[7.1]
  def change
    create_table :units do |t|
      t.string :name, null: false
      t.string :description
      t.text :content, null: false
      t.integer :sort_key, null: false
      t.references :chapter, null: false, foreign_key: true
      t.timestamps
    end
  end
end
