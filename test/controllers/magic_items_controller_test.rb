require 'test_helper'

class MagicItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @magic_item = magic_items(:one)
  end

  test "should get index" do
    get magic_items_url
    assert_response :success
  end

  test "should get new" do
    get new_magic_item_url
    assert_response :success
  end

  test "should create magic_item" do
    assert_difference('MagicItem.count') do
      post magic_items_url, params: { magic_item: { character_id: @magic_item.character_id, name: @magic_item.name, tp: @magic_item.tp } }
    end

    assert_redirected_to magic_item_url(MagicItem.last)
  end

  test "should show magic_item" do
    get magic_item_url(@magic_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_magic_item_url(@magic_item)
    assert_response :success
  end

  test "should update magic_item" do
    patch magic_item_url(@magic_item), params: { magic_item: { character_id: @magic_item.character_id, name: @magic_item.name, tp: @magic_item.tp } }
    assert_redirected_to magic_item_url(@magic_item)
  end

  test "should destroy magic_item" do
    assert_difference('MagicItem.count', -1) do
      delete magic_item_url(@magic_item)
    end

    assert_redirected_to magic_items_url
  end
end
