defmodule Risk4.SharedTest do
  use Risk4.DataCase

  alias Risk4.Shared

  describe "statuses" do
    alias Risk4.Shared.Status

    import Risk4.SharedFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_statuses/0 returns all statuses" do
      status = status_fixture()
      assert Shared.list_statuses() == [status]
    end

    test "get_status!/1 returns the status with given id" do
      status = status_fixture()
      assert Shared.get_status!(status.id) == status
    end

    test "create_status/1 with valid data creates a status" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Status{} = status} = Shared.create_status(valid_attrs)
      assert status.description == "some description"
      assert status.name == "some name"
    end

    test "create_status/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shared.create_status(@invalid_attrs)
    end

    test "update_status/2 with valid data updates the status" do
      status = status_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Status{} = status} = Shared.update_status(status, update_attrs)
      assert status.description == "some updated description"
      assert status.name == "some updated name"
    end

    test "update_status/2 with invalid data returns error changeset" do
      status = status_fixture()
      assert {:error, %Ecto.Changeset{}} = Shared.update_status(status, @invalid_attrs)
      assert status == Shared.get_status!(status.id)
    end

    test "delete_status/1 deletes the status" do
      status = status_fixture()
      assert {:ok, %Status{}} = Shared.delete_status(status)
      assert_raise Ecto.NoResultsError, fn -> Shared.get_status!(status.id) end
    end

    test "change_status/1 returns a status changeset" do
      status = status_fixture()
      assert %Ecto.Changeset{} = Shared.change_status(status)
    end
  end

  describe "categories" do
    alias Risk4.Shared.Category

    import Risk4.SharedFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Shared.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Shared.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Category{} = category} = Shared.create_category(valid_attrs)
      assert category.description == "some description"
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shared.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Category{} = category} = Shared.update_category(category, update_attrs)
      assert category.description == "some updated description"
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Shared.update_category(category, @invalid_attrs)
      assert category == Shared.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Shared.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Shared.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Shared.change_category(category)
    end
  end

  describe "users" do
    alias Risk4.Shared.User

    import Risk4.SharedFixtures

    @invalid_attrs %{avatar: nil, email: nil, fname: nil, level: nil, lname: nil, phone: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Shared.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Shared.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{avatar: "some avatar", email: "some email", fname: "some fname", level: 42, lname: "some lname", phone: "some phone"}

      assert {:ok, %User{} = user} = Shared.create_user(valid_attrs)
      assert user.avatar == "some avatar"
      assert user.email == "some email"
      assert user.fname == "some fname"
      assert user.level == 42
      assert user.lname == "some lname"
      assert user.phone == "some phone"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shared.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{avatar: "some updated avatar", email: "some updated email", fname: "some updated fname", level: 43, lname: "some updated lname", phone: "some updated phone"}

      assert {:ok, %User{} = user} = Shared.update_user(user, update_attrs)
      assert user.avatar == "some updated avatar"
      assert user.email == "some updated email"
      assert user.fname == "some updated fname"
      assert user.level == 43
      assert user.lname == "some updated lname"
      assert user.phone == "some updated phone"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Shared.update_user(user, @invalid_attrs)
      assert user == Shared.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Shared.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Shared.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Shared.change_user(user)
    end
  end
end
