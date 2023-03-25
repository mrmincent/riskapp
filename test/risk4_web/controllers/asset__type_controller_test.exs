defmodule Risk4Web.Asset_TypeControllerTest do
  use Risk4Web.ConnCase

  import Risk4.AssetFixtures

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  describe "index" do
    test "lists all asset_types", %{conn: conn} do
      conn = get(conn, ~p"/asset_types")
      assert html_response(conn, 200) =~ "Listing Asset types"
    end
  end

  describe "new asset__type" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/asset_types/new")
      assert html_response(conn, 200) =~ "New Asset  type"
    end
  end

  describe "create asset__type" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/asset_types", asset__type: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/asset_types/#{id}"

      conn = get(conn, ~p"/asset_types/#{id}")
      assert html_response(conn, 200) =~ "Asset  type #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/asset_types", asset__type: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Asset  type"
    end
  end

  describe "edit asset__type" do
    setup [:create_asset__type]

    test "renders form for editing chosen asset__type", %{conn: conn, asset__type: asset__type} do
      conn = get(conn, ~p"/asset_types/#{asset__type}/edit")
      assert html_response(conn, 200) =~ "Edit Asset  type"
    end
  end

  describe "update asset__type" do
    setup [:create_asset__type]

    test "redirects when data is valid", %{conn: conn, asset__type: asset__type} do
      conn = put(conn, ~p"/asset_types/#{asset__type}", asset__type: @update_attrs)
      assert redirected_to(conn) == ~p"/asset_types/#{asset__type}"

      conn = get(conn, ~p"/asset_types/#{asset__type}")
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, asset__type: asset__type} do
      conn = put(conn, ~p"/asset_types/#{asset__type}", asset__type: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Asset  type"
    end
  end

  describe "delete asset__type" do
    setup [:create_asset__type]

    test "deletes chosen asset__type", %{conn: conn, asset__type: asset__type} do
      conn = delete(conn, ~p"/asset_types/#{asset__type}")
      assert redirected_to(conn) == ~p"/asset_types"

      assert_error_sent 404, fn ->
        get(conn, ~p"/asset_types/#{asset__type}")
      end
    end
  end

  defp create_asset__type(_) do
    asset__type = asset__type_fixture()
    %{asset__type: asset__type}
  end
end
