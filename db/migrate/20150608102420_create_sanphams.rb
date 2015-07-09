class CreateSanphams < ActiveRecord::Migration
  def change
    create_table :sanphams do |t|
      t.string :ten
      t.integer :gia
      t.references :hedieuhanh, index: true
      t.string :dophangiaimanhinh
      t.float :camera
      t.integer :bonhotrong
      t.integer :thenhongoai
      t.integer :ram
      t.integer :pin
      t.string :cpu
      t.references :hangsanxuat, index: true
      t.string :hinhanh

      t.timestamps
    end
  end
end
