require 'test_helper'

class IncomingRequestsControllerTest < ActionDispatch::IntegrationTest
  test "POST /api/v1/addexpense should save incoming request and add enqued job" do
    assert_enqueued_jobs 0
    
    api_user = api_users(:active)
    post api_v1_addexpense_path, headers: { HTTP_AUTHORIZATION: "Token token=#{api_user.token}", 'Content-Type' => 'application/json' }, params: {sum: 100}, as: :json
    
    assert_enqueued_jobs 1
    
    assert_response :success

  end

  test "POST /api/v1/addexpense with invalid token shouldn't save incoming request" do
    api_user = api_users(:active)
    post api_v1_addexpense_path, headers: { HTTP_AUTHORIZATION: "Token token=bad" }
    assert_response :unauthorized
  end

  test "POST /api/v1/addexpense not active API user shouldn't save incoming request" do
    api_user = api_users(:not_active)
    post api_v1_addexpense_path, headers: { HTTP_AUTHORIZATION: "Token token=#{api_user.token}" }
    assert_response :unauthorized
  end
end