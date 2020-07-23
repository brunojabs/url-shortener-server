class CreateUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :urls do |t|
      t.string :target, null: false
      t.integer :hits, default: 0

      t.timestamps
    end
  end
end
