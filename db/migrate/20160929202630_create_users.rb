class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :netid
      t.string :name
      t.string :lastname
      t.string :firstname
      t.string :email
      t.string :deptclass
      t.string :role, null: false, default: 'user'

      t.timestamps
    end
    add_index :users, :netid
    add_index :users, :name
    add_index :users, :lastname
  end
end
