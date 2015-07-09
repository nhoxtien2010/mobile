class HomeController < ApplicationController  
  
  #bang toan cuc cho C
  def index
    @hangsanxuats = Hangsanxuat.all
    @hedieuhanhs = Hedieuhanh.all
    if(@sanpham == nil)
      @sanphams = Sanpham.where(:hangsanxuat_id => 4)
    end
    
    
#     gia ban
    gb = session[:giaban]
    if gb!= nil
      session[:giaban]=nil
      if gb == 1      
        @sanphams = Sanpham.where('gia <= 3000000')
      elsif gb ==2
        @sanphams = Sanpham.where('gia > 3000000 and gia <= 5000000')  
      elsif gb ==3
        @sanphams = Sanpham.where('gia > 5000000 and gia <= 7000000')          
      elsif gb ==4
        @sanphams = Sanpham.where('gia > 7000000 and gia <= 10000000')          
      else
        @sanphams = Sanpham.where('gia <= 10000000')                 
          
      end
      
    end
    
    # tim theo hang san xuat
    if session[:hsx]!= nil
      @sanphams = Sanpham.where(:hangsanxuat_id => session[:hsx])
      session[:hsx]= nil  
    end
    
    # tim theo he dieu hanh
    if session[:hedieuhanh]!= nil
      @sanphams = Sanpham.where(:hedieuhanh_id => session[:hedieuhanh])
      session[:hedieuhanh]= nil  
    end
    # tim theo ten san pham
    if session[:keyword_string]!= nil
      @sanphams = Sanpham.where("ten LIKE '%"+session[:keyword_string].to_s+"%'")
      session[:keyword_string]= nil  
    end
    
  end
  
  def change_sanpham_hangsanxuat
    hangsanxuat_id = params[:hsx].to_i 
    session[:hsx] = hangsanxuat_id  
    render :js => "document.location.reload()"
  end
  
  def change_sanpham_giaban
    giaban = params[:giaban].to_i      
    session[:giaban] = giaban 
    render :js => "document.location.reload()"
  end
  def change_sanpham_hedieuhanh
    hedieuhanh = params[:hedieuhanh].to_i      
    session[:hedieuhanh] = hedieuhanh 
    render :js => "document.location.reload()"
  end
  
  def change_sanpham_ten
    keyword_string = params[:keyword_string]
    session[:keyword_string] = keyword_string 
    render :js => "document.location.reload()" 
  end
  
  #   xay dung tap du lieu D bao gom cac item va du lieu tuong ung
  def build_tapnguon
    connection = ActiveRecord::Base.connection    
    bang_dulieu_tho = connection.execute("select sanpham_id, ngay from giaodiches order by sanpham_id")
    #     return mot bang kieu hash
    
    #     khai bao mot tap rong
    @tapnguon = []
    # xu ly bang du lieu
    hash_item = Hash.new    
    bang_dulieu_tho.each do |d|
      if hash_item["item"] == nil
        hash_item["item"] = []
        hash_item["item"] << d["sanpham_id"]
        hash_item["transaction"] = []
        hash_item["transaction"] << d["ngay"]
      elsif hash_item["item"].last == d["sanpham_id"]
        hash_item["transaction"] << d["ngay"]
      elsif d != bang_dulieu_tho.last
        #qua san pham khac, add item vo tapnguon, tao moi hash item
        bientam = hash_item
        @tapnguon << bientam
        hash_item = Hash.new
        hash_item["item"] = []
        hash_item["item"] << d["sanpham_id"]
        hash_item["transaction"] = []
        hash_item["transaction"] << d["ngay"]
      else
        @tapnguon<< hash_item
      end
    end
    return @tapnguon
  end
  
  def convert_array_tos(array)
    @s=""
    array.each do |a|
      @s+= a.to_s
    end
    return @s
  end
  
  
#   phep giao
  def phantuchung_hai_mang(a,b)
    @ketqua = []
    a.each do |aa|
      b.each do |bb|
        if(aa==bb)
          @ketqua<<aa
        end
      end
    end
    return @ketqua
  end
  
#   phep hop
def gop_hai_mang(a,b)
    @ketqua = []
    a.each do |aa|
      @flag =1      
      b.each do |bb|                
        if(aa==bb)
          @flag =0        
        end
      end
      if @flag ==1
        @ketqua<<aa
      end
      
    end
    
    b.each do |bb|
      @ketqua<<bb
    end
    
    return @ketqua
  end



  
  def charm(tapnguon, minsup)
    @Root = Tree::TreeNode.new("ROOT", nil)
    tapnguon.each do |d|
      if d["transaction"].length >= 3
        @Root << Tree::TreeNode.new(convert_array_tos(d["item"]), d)
      end
    end
#     C la tap hop cac tap pho bien dong
    @C = [] 
    charm_extend(@Root,@C,minsup)
    return @C
  end
  
  def charm_extend(root,c,minsup)
    (0..root.children.length-1).each do |i|
      (i+1 .. root.children.length-1) do |j|
        @X = root.children[j].content["item"]
        @Y = phantuchung_hai_mang(root.children[i].content["transaction"],root.children[j].content["transaction"])
        if @Y>minsup
          charm_property(@X,@Y, @Root,root[i],root[j])
        end
      end
      if !supsumtion_text(@C, root[i])
        @C << prefix(root[i])
        charm_extend(root[i], @C, minsup)
        
      end
      remove_instance_variable(@root[i])
        
    end
    return @C
    
  end
  
  def tapcon(a,b)
    
    a.each do |aa|
      flag = false
      b.each do |bb|
        if aa==bb
          flag = true
        end
      end
      if flag == false
        return false
      end
    end
    return true
  end
      
  
  
  def charm_property(x,y,n,ni,nj)
    if(ni.content["transaction"] == nj.content["transaction"])
      ni.content["item"] = gop_hai_mang(ni.content["item"], nj.conetn["item"])
      n.children.remove!(nj)
    elsif tapcon(ni.content["transaction"], nj.content["transaction"])
      ni.content["item"] = gop_hai_mang(ni.content["item"], nj.content["item"])
    elsif tapcon(nj.content["transaction"], ni.content["transaction"])
      hash_item = Hash.new
      hash.item["item"] << x
      hash.item["transaction"]<<y
      ni<< Tree::TreeNode.new(convert_array_tos(x), hash_item) 
      n.children.remove!(nj)
    else
      hash_item = Hash.new
      hash.item["item"] << x
      hash.item["transaction"]<<y
      ni<< Tree::TreeNode.new(convert_array_tos(x), hash_item) 
      
      
    end
  
      
  end
  
  
  # xi bi phu boi xj
  def single_supsumtion_check(xi,xj)
    x[i]["transaction.length"] = xj["transaction.length"]
    xi["item"].each do |xii|
      flag = false
      xj["item"].each do |xji|
        if xii == xji
          flag = true
        end
      end
      if flag == false
        return false
      end
    end
    return true
  end
  
  # c tap cac nut thoa dieu kien
  # n mot nut kiem tra xem co bi phu boi c khong
  def supsumtion_check(c,n)
    c.each do |y|
      if y.content["transaction"].length === n.content["transaction"].length and y.content["transaction"] === n.content["transaction"]
        return true
      end    
    end
    
    return false     
    
  end
  
  
#   cac phan tu truoc n
  def prefix(n)
    n.content["item"] = gop_hai_mang(n.content["item"],n.parent.content["item"])
  end
  
  
  
  
end
