defmodule Risk4Web.ThreatControllerTest do
  use Risk4Web.ConnCase

  import Risk4.AssessmentFixtures

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  describe "index" do
    test "lists all threats", %{conn: conn} do
      conn = get(conn, ~p"/threats")
      assert html_response(conn, 200) =~ "Listing Threats"
    end
  end

  describe "new threat" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/threats/new")
      assert html_response(conn, 200) =~ "New Threat"
    end
  end

  describe "create threat" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/threats", threat: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/threats/#{id}"

      conn = get(conn, ~p"/threats/#{id}")
      assert html_response(conn, 200) =~ "Threat #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/threats", threat: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Threat"
    end
  end

  describe "edit threat" do
    setup [:create_threat]

    test "renders form for editing chosen threat", %{conn: conn, threat: threat} do
      conn = get(conn, ~p"/threats/#{threat}/edit")
      assert html_response(conn, 200) =~ "Edit Threat"
    end
  end

  describe "update threat" do
    setup [:create_threat]

    test "redirects when data is valid", %{conn: conn, threat: threat} do
      conn = put(conn, ~p"/threats/#{threat}", threat: @update_attrs)
      assert redirected_to(conn) == ~p"/threats/#{threat}"

      conn = get(conn, ~p"/threats/#{threat}")
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, threat: threat} do
      conn = put(conn, ~p"/threats/#{threat}", threat: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Threat"
    end
  end

  describe "delete threat" do
    setup [:create_threat]

    test "deletes chosen threat", %{conn: conn, threat: threat} do
      conn = delete(conn, ~p"/threats/#{threat}")
      assert redirected_to(conn) == ~p"/threats"

      assert_error_sent 404, fn ->
        get(conn, ~p"/threats/#{threat}")
      end
    end
  end

  defp create_threat(_) do
    threat = threat_fixture()
    %{threat: threat}
  end
end
