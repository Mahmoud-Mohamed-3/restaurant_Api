class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :title, null: false, default: ""

      t.timestamps
    end
  end
end
