require 'test_helper'

class GiaodichesControllerTest < ActionController::TestCase
  setup do
    @giaodich = giaodiches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:giaodiches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create giaodich" do
    assert_difference('Giaodich.count') do
      post :create, giaodich: {  }
    end

    assert_redirected_to giaodich_path(assigns(:giaodich))
  end

  test "should show giaodich" do
    get :show, id: @giaodich
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @giaodich
    assert_response :success
  end

  test "should update giaodich" do
    patch :update, id: @giaodich, giaodich: {  }
    assert_redirected_to giaodich_path(assigns(:giaodich))
  end

  test "should destroy giaodich" do
    assert_difference('Giaodich.count', -1) do
      delete :destroy, id: @giaodich
    end

    assert_redirected_to giaodiches_path
  end
end
