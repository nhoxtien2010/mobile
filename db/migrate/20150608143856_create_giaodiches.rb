class CreateGiaodiches < ActiveRecord::Migration
  def change
    create_table :giaodiches do |t|
      t.date :ngay
      t.references :sanpham, index: true
      t.timestamps
    end
  end
end
