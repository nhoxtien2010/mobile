class GiaodichesController < ApplicationController
  def create
    # time = Time.now.to_s
    # ngay = DateTime.parse(time).strftime("%Y-%m-%d")
    # sanpham_id = params[:sanpham_id].to_i
    # giaodich = Giaodich.new(ngay,sanpham_id)
    # giaodich.save
    render :js => "alert('Xin chúc mừng, Bạn đã mua sản phẩm này thành công!!')"
  end
end
