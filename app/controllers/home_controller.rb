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

  def sanpham
    @hangsanxuats = Hangsanxuat.all
    @hedieuhanhs = Hedieuhanh.all
    @sanpham = Sanpham.find(params[:id])
    if session[:ketqua_timkiem]!=nil
      @ketqua_timkiem = session[:ketqua_timkiem]
    else
      @ketqua_timkiem = []
    end
  end
  
  def search
    keyword_string = params[:keyword_string]
    soluong = keyword_string.to_i
    danhsach = apriori(7)#set minsuf =7
    bangtam = []
    danhsach.each do |dss|
      dss.each do |ds| 
        if ds["item"].length == soluong
          ds["item"].each do |dsitem|
            bangtam << dsitem
          end
        end
      end
    end
     
    @ketqua = []
    bangtam.each do |bangtamitem|
      unless @ketqua.include?bangtamitem
        @ketqua << bangtamitem 
      end      
    end
    
    session[:ketqua_timkiem] = @ketqua    
    render :js => "document.location.reload()"
  end

# ====================thuat toan apriori=================================
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
    if (1== nil or b==nil)
      return
    end
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
  
#   so sanh hai mang
def compare (a,b)
  if a.length != b.length
    return false
  end
  
  a.each do |aa|
    flag = false
    b.each do |bb|
      if aa == bb
        flag = true
      end
    end
    if flag == false
      return false
    end
  end
  return true
end





  def apriori(minsup)
    
    @l = [] # tap cac muc pho bien can tim
    # khoi tao l[0] la tap du lieu nguon
    l0 = []
    build_tapnguon.each do |item|
      if item["transaction"].length >= minsup
        l0 << item
      end
    end
    @l<<l0    

    k=1
    l = l0.clone
    
    

    while build_tap_pho_bien(l,minsup).length != l.length do      
      
      bientam = build_tap_pho_bien(l,minsup).clone      
      @l<<bientam      
      l= @l[k].clone
      k+=1
        
    end
    
    return @l.clone
    
      
  end

  def build_tap_pho_bien(l,minsup)# build tap pho bien l[k] tu l[k-1]
    @result = []
    (0 .. l.length-2).each do |i|
      (i+1 .. l.length-1).each do |j|
        if phantuchung_hai_mang(l[i]["transaction"], l[j]["transaction"]).length >= minsup
          hash_item = Hash.new
          hash_item["item"] = []
          hash_item["transaction"] = []
          phantuchung_hai_mang(l[i]["transaction"], l[j]["transaction"]).each do |new_transaction|
            hash_item["transaction"]<< new_transaction
          end
          gop_hai_mang(l[i]["item"], l[j]["item"]).each do |new_it|
            hash_item["item"]<< new_it
          end

          @result << hash_item
        end
      end
    end
    
    return @result
    
  end
  
  
# ======================thuat toan charm=============================================
#   def charm(tapnguon, minsup)
#     @root = Tree::TreeNode.new("@root", nil)
#     tapnguon.each do |d|
#       if d["transaction"].length >= minsup
#         @root << Tree::TreeNode.new(convert_array_tos(d["item"]), d)
#       end
#     end
# #     C la tap hop cac tap pho bien dong
#     @C = [] 
#     charm_extend(@root,@C,minsup)
#     return @C
#   end
  
#   def charm_extend(root,c,minsup)
#     (0 .. root.children.length-2).each do |i|
#       (i+1 .. root.children.length-1).each do |j|
#         if root.children[j]!= nil        
#           @X = root.children[j].content["item"]
#           @Y = phantuchung_hai_mang(root.children[i].content["transaction"],root.children[j].content["transaction"])
#           if @Y.length >= minsup
#             charm_property(@X,@Y, root,root.children[i],root.children[j])
#           end
#         end
#       end
#       if !supsumtion_check(@C, root.children[i])
#         if root.children != nil
#           @C << prefix(root.children[i])
#           charm_extend(root.children[i], @C, minsup)
#         end

        
#       end
#       remove_instance_variable(root.children[i])
        
#     end
#     return @C
    
#   end
  
#   def tapcon(a,b)
    
#     a.each do |aa|
#       flag = false
#       b.each do |bb|
#         if aa==bb
#           flag = true
#         end
#       end
#       if flag == false
#         return false
#       end
#     end
#     return true
#   end
      
  
  
#   def charm_property(x,y,n,ni,nj)
#     if(ni.content["transaction"] == nj.content["transaction"])
#       ni.content["item"] = gop_hai_mang(ni.content["item"], nj.content["item"])
#       n.remove!(nj)
#     elsif tapcon(ni.content["transaction"], nj.content["transaction"])
#       ni.content["item"] = gop_hai_mang(ni.content["item"], nj.content["item"])
#     elsif tapcon(nj.content["transaction"], ni.content["transaction"])
#       hash_item = Hash.new
#       hash_item["item"] = []
#       hash_item["transaction"] = []
#       hash_item["item"] = x
#       hash_item["transaction"]= y
#       node = Tree::TreeNode.new(convert_array_tos(x), hash_item)
#       if !check_exist(ni,node)
#         ni<< node 
#       end
#       n.remove!(nj)
#     else
#       hash_item = Hash.new
#       hash_item["item"] = []
#       hash_item["transaction"] = []
#       hash_item["item"] = x
#       hash_item["transaction"]= y
#       node = Tree::TreeNode.new(convert_array_tos(x), hash_item)
#       if !check_exist(ni,node)
#         ni<< node 
#       end      
#     end
#   end
  
  
  
#   # c tap cac nut thoa dieu kien
#   # n mot nut kiem tra xem co bi phu boi c khong
#   def supsumtion_check(c,n)
#     c.each do |y|
#       if y.content["transaction"].length === n.content["transaction"].length and y.content["transaction"] === n.content["transaction"]
#         return true
#       end    
#     end
    
#     return false     
    
#   end
  
  
# #   cac phan tu truoc n
#   def prefix(n)

#     n.content["item"] = gop_hai_mang(n.content["item"],n.parent.content["item"])     
    
#   end 

#   def check_exist(root, node)
#     root.children.each do |chd|
#       chd === node
#       return true
#       if check_exist(chd,node) 
#         return true
#       end
#     end
#     return false
#   end 


end





