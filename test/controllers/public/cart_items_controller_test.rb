require "test_helper"

class Public::CartItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_cart_items_index_url
    assert_response :success
  end

  test "should get destroy_all" do
    get public_cart_items_destroy_all_url
    assert_response :success
  end
end
