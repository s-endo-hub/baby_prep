class CreatePreparationItems < ActiveRecord::Migration[7.2]
  def change
    create_table :preparation_items do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :category, null: false
      t.string :status, null: false, default: "not_ready"

      t.timestamps
    end
  end
end