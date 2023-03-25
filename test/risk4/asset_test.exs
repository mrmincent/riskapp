defmodule Risk4.AssetTest do
  use Risk4.DataCase

  alias Risk4.Asset

  describe "asset_types" do
    alias Risk4.Asset.Asset_Type

    import Risk4.AssetFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_asset_types/0 returns all asset_types" do
      asset__type = asset__type_fixture()
      assert Asset.list_asset_types() == [asset__type]
    end

    test "get_asset__type!/1 returns the asset__type with given id" do
      asset__type = asset__type_fixture()
      assert Asset.get_asset__type!(asset__type.id) == asset__type
    end

    test "create_asset__type/1 with valid data creates a asset__type" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Asset_Type{} = asset__type} = Asset.create_asset__type(valid_attrs)
      assert asset__type.description == "some description"
      assert asset__type.name == "some name"
    end

    test "create_asset__type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Asset.create_asset__type(@invalid_attrs)
    end

    test "update_asset__type/2 with valid data updates the asset__type" do
      asset__type = asset__type_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Asset_Type{} = asset__type} = Asset.update_asset__type(asset__type, update_attrs)
      assert asset__type.description == "some updated description"
      assert asset__type.name == "some updated name"
    end

    test "update_asset__type/2 with invalid data returns error changeset" do
      asset__type = asset__type_fixture()
      assert {:error, %Ecto.Changeset{}} = Asset.update_asset__type(asset__type, @invalid_attrs)
      assert asset__type == Asset.get_asset__type!(asset__type.id)
    end

    test "delete_asset__type/1 deletes the asset__type" do
      asset__type = asset__type_fixture()
      assert {:ok, %Asset_Type{}} = Asset.delete_asset__type(asset__type)
      assert_raise Ecto.NoResultsError, fn -> Asset.get_asset__type!(asset__type.id) end
    end

    test "change_asset__type/1 returns a asset__type changeset" do
      asset__type = asset__type_fixture()
      assert %Ecto.Changeset{} = Asset.change_asset__type(asset__type)
    end
  end

  describe "items" do
    alias Risk4.Asset.Item

    import Risk4.AssetFixtures

    @invalid_attrs %{availablity: nil, confidentiality: nil, integrity: nil, justification: nil, name: nil, value: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Asset.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Asset.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{availablity: 42, confidentiality: 42, integrity: 42, justification: "some justification", name: "some name", value: 42}

      assert {:ok, %Item{} = item} = Asset.create_item(valid_attrs)
      assert item.availablity == 42
      assert item.confidentiality == 42
      assert item.integrity == 42
      assert item.justification == "some justification"
      assert item.name == "some name"
      assert item.value == 42
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Asset.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{availablity: 43, confidentiality: 43, integrity: 43, justification: "some updated justification", name: "some updated name", value: 43}

      assert {:ok, %Item{} = item} = Asset.update_item(item, update_attrs)
      assert item.availablity == 43
      assert item.confidentiality == 43
      assert item.integrity == 43
      assert item.justification == "some updated justification"
      assert item.name == "some updated name"
      assert item.value == 43
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Asset.update_item(item, @invalid_attrs)
      assert item == Asset.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Asset.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Asset.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Asset.change_item(item)
    end
  end
end
