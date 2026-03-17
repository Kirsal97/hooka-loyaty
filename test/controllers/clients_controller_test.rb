require "test_helper"

class ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(employees(:one))
    @client = clients(:john)
  end

  # new
  test "new renders successfully" do
    get new_client_path
    assert_response :success
  end

  # create - valid params
  test "create with valid params creates client and redirects" do
    assert_difference "Client.count", 1 do
      post clients_path, params: { client: { name: "Alice Walker", phone: "5550001111" } }
    end
    assert_redirected_to client_path(Client.last)
  end

  # create - invalid params
  test "create with invalid params renders new with unprocessable_entity" do
    assert_no_difference "Client.count" do
      post clients_path, params: { client: { name: "", phone: "5550002222" } }
    end
    assert_response :unprocessable_entity
  end

  # show
  test "show renders successfully" do
    get client_path(@client)
    assert_response :success
  end

  # edit
  test "edit renders successfully" do
    get edit_client_path(@client)
    assert_response :success
  end

  # update - valid params
  test "update with valid params updates client and redirects" do
    patch client_path(@client), params: { client: { name: "John Updated", phone: @client.phone } }
    assert_redirected_to client_path(@client)
    assert_equal "John Updated", @client.reload.name
  end

  # update - invalid params
  test "update with invalid params renders edit with unprocessable_entity" do
    patch client_path(@client), params: { client: { name: "", phone: @client.phone } }
    assert_response :unprocessable_entity
    assert_equal "John Doe", @client.reload.name
  end

  # unauthenticated access
  test "unauthenticated requests redirect to login" do
    sign_out

    get new_client_path
    assert_redirected_to new_session_path
  end
end
