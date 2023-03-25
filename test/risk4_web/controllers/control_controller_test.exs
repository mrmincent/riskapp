defmodule Risk4Web.ControlControllerTest do
  use Risk4Web.ConnCase

  import Risk4.AssessmentFixtures

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  describe "index" do
    test "lists all controls", %{conn: conn} do
      conn = get(conn, ~p"/controls")
      assert html_response(conn, 200) =~ "Listing Controls"
    end
  end

  describe "new control" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/controls/new")
      assert html_response(conn, 200) =~ "New Control"
    end
  end

  describe "create control" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/controls", control: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/controls/#{id}"

      conn = get(conn, ~p"/controls/#{id}")
      assert html_response(conn, 200) =~ "Control #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/controls", control: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Control"
    end
  end

  describe "edit control" do
    setup [:create_control]

    test "renders form for editing chosen control", %{conn: conn, control: control} do
      conn = get(conn, ~p"/controls/#{control}/edit")
      assert html_response(conn, 200) =~ "Edit Control"
    end
  end

  describe "update control" do
    setup [:create_control]

    test "redirects when data is valid", %{conn: conn, control: control} do
      conn = put(conn, ~p"/controls/#{control}", control: @update_attrs)
      assert redirected_to(conn) == ~p"/controls/#{control}"

      conn = get(conn, ~p"/controls/#{control}")
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, control: control} do
      conn = put(conn, ~p"/controls/#{control}", control: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Control"
    end
  end

  describe "delete control" do
    setup [:create_control]

    test "deletes chosen control", %{conn: conn, control: control} do
      conn = delete(conn, ~p"/controls/#{control}")
      assert redirected_to(conn) == ~p"/controls"

      assert_error_sent 404, fn ->
        get(conn, ~p"/controls/#{control}")
      end
    end
  end

  defp create_control(_) do
    control = control_fixture()
    %{control: control}
  end
end
