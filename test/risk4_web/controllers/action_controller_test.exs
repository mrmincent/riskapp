defmodule Risk4Web.ActionControllerTest do
  use Risk4Web.ConnCase

  import Risk4.AssessmentFixtures

  @create_attrs %{description: "some description", due_date: ~D[2023-03-21], title: "some title"}
  @update_attrs %{description: "some updated description", due_date: ~D[2023-03-22], title: "some updated title"}
  @invalid_attrs %{description: nil, due_date: nil, title: nil}

  describe "index" do
    test "lists all actions", %{conn: conn} do
      conn = get(conn, ~p"/actions")
      assert html_response(conn, 200) =~ "Listing Actions"
    end
  end

  describe "new action" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/actions/new")
      assert html_response(conn, 200) =~ "New Action"
    end
  end

  describe "create action" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/actions", action: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/actions/#{id}"

      conn = get(conn, ~p"/actions/#{id}")
      assert html_response(conn, 200) =~ "Action #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/actions", action: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Action"
    end
  end

  describe "edit action" do
    setup [:create_action]

    test "renders form for editing chosen action", %{conn: conn, action: action} do
      conn = get(conn, ~p"/actions/#{action}/edit")
      assert html_response(conn, 200) =~ "Edit Action"
    end
  end

  describe "update action" do
    setup [:create_action]

    test "redirects when data is valid", %{conn: conn, action: action} do
      conn = put(conn, ~p"/actions/#{action}", action: @update_attrs)
      assert redirected_to(conn) == ~p"/actions/#{action}"

      conn = get(conn, ~p"/actions/#{action}")
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, action: action} do
      conn = put(conn, ~p"/actions/#{action}", action: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Action"
    end
  end

  describe "delete action" do
    setup [:create_action]

    test "deletes chosen action", %{conn: conn, action: action} do
      conn = delete(conn, ~p"/actions/#{action}")
      assert redirected_to(conn) == ~p"/actions"

      assert_error_sent 404, fn ->
        get(conn, ~p"/actions/#{action}")
      end
    end
  end

  defp create_action(_) do
    action = action_fixture()
    %{action: action}
  end
end
