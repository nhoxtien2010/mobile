class Sanpham < ActiveRecord::Base
  belongs_to :hedieuhanh
  belongs_to :hangsanxuat
end
