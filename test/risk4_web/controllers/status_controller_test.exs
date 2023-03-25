defmodule Risk4Web.StatusControllerTest do
  use Risk4Web.ConnCase

  import Risk4.SharedFixtures

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  describe "index" do
    test "lists all statuses", %{conn: conn} do
      conn = get(conn, ~p"/statuses")
      assert html_response(conn, 200) =~ "Listing Statuses"
    end
  end

  describe "new status" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/statuses/new")
      assert html_response(conn, 200) =~ "New Status"
    end
  end

  describe "create status" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/statuses", status: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/statuses/#{id}"

      conn = get(conn, ~p"/statuses/#{id}")
      assert html_response(conn, 200) =~ "Status #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/statuses", status: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Status"
    end
  end

  describe "edit status" do
    setup [:create_status]

    test "renders form for editing chosen status", %{conn: conn, status: status} do
      conn = get(conn, ~p"/statuses/#{status}/edit")
      assert html_response(conn, 200) =~ "Edit Status"
    end
  end

  describe "update status" do
    setup [:create_status]

    test "redirects when data is valid", %{conn: conn, status: status} do
      conn = put(conn, ~p"/statuses/#{status}", status: @update_attrs)
      assert redirected_to(conn) == ~p"/statuses/#{status}"

      conn = get(conn, ~p"/statuses/#{status}")
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, status: status} do
      conn = put(conn, ~p"/statuses/#{status}", status: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Status"
    end
  end

  describe "delete status" do
    setup [:create_status]

    test "deletes chosen status", %{conn: conn, status: status} do
      conn = delete(conn, ~p"/statuses/#{status}")
      assert redirected_to(conn) == ~p"/statuses"

      assert_error_sent 404, fn ->
        get(conn, ~p"/statuses/#{status}")
      end
    end
  end

  defp create_status(_) do
    status = status_fixture()
    %{status: status}
  end
end
