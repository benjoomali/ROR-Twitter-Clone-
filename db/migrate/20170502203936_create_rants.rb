class CreateRants < ActiveRecord::Migration[5.0]
  def change
    create_table :rants do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :rants, [:user_id, :created_at]
  end
end
