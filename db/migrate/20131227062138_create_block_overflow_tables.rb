class CreateBlockOverflowTables < ActiveRecord::Migration
  def up
  	create_table :users do |t|
  		t.string :first_name
  		t.string :last_name
  		t.string :username
  		t.string :password
  		t.string :image
  		t.timestamps
  	end

  	create_table :posts do |t|
  		t.string :title
  		t.text   :body
  		t.belongs_to :user
  		t.timestamps
  	end

  	create_table :comments do |t|
  		t.string :body
  		t.belongs_to :user
  		t.belongs_to :post
  		t.timestamps
  	end

  	create_table :likes do |t|
  		t.belongs_to :user
  		t.belongs_to :post
  		t.belongs_to :comment
  		t.timestamps
  	end
  end

  def down
  	drop_table :users
  	drop_table :posts
  	drop_table :comments
  	drop_table :likes
  end
end