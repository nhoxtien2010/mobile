class CreateHangsanxuats < ActiveRecord::Migration
  def change
    create_table :hangsanxuats do |t|
      t.string :ten
      t.string :hinhanh
      t.string :diachi

      t.timestamps
    end
  end
end
