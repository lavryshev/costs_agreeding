require 'test_helper'

class IncomingRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should create expense" do
    api_user = api_users(:active)
    post api_v1_addexpense_path, headers: { HTTP_AUTHORIZATION: "Token token=#{api_user.token}" }
    assert_response :success
  end

  test "with invalid token shouldn't create expense" do
    api_user = api_users(:active)
    post api_v1_addexpense_path, headers: { HTTP_AUTHORIZATION: "Token token=bad" }
    assert_response :unauthorized
  end

  test "not active API user shouldn't create expense" do
    api_user = api_users(:not_active)
    post api_v1_addexpense_path, headers: { HTTP_AUTHORIZATION: "Token token=#{api_user.token}" }
    assert_response :unauthorized
  end
end