defmodule Risk4Web.LoginAuthTest do
  use Risk4Web.ConnCase, async: true

  alias Phoenix.LiveView
  alias Risk4.Accounts
  alias Risk4Web.LoginAuth
  import Risk4.AccountsFixtures

  @remember_me_cookie "_risk4_web_login_remember_me"

  setup %{conn: conn} do
    conn =
      conn
      |> Map.replace!(:secret_key_base, Risk4Web.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    %{login: login_fixture(), conn: conn}
  end

  describe "log_in_login/3" do
    test "stores the login token in the session", %{conn: conn, login: login} do
      conn = LoginAuth.log_in_login(conn, login)
      assert token = get_session(conn, :login_token)
      assert get_session(conn, :live_socket_id) == "logins_sessions:#{Base.url_encode64(token)}"
      assert redirected_to(conn) == ~p"/"
      assert Accounts.get_login_by_session_token(token)
    end

    test "clears everything previously stored in the session", %{conn: conn, login: login} do
      conn = conn |> put_session(:to_be_removed, "value") |> LoginAuth.log_in_login(login)
      refute get_session(conn, :to_be_removed)
    end

    test "redirects to the configured path", %{conn: conn, login: login} do
      conn = conn |> put_session(:login_return_to, "/hello") |> LoginAuth.log_in_login(login)
      assert redirected_to(conn) == "/hello"
    end

    test "writes a cookie if remember_me is configured", %{conn: conn, login: login} do
      conn = conn |> fetch_cookies() |> LoginAuth.log_in_login(login, %{"remember_me" => "true"})
      assert get_session(conn, :login_token) == conn.cookies[@remember_me_cookie]

      assert %{value: signed_token, max_age: max_age} = conn.resp_cookies[@remember_me_cookie]
      assert signed_token != get_session(conn, :login_token)
      assert max_age == 5_184_000
    end
  end

  describe "logout_login/1" do
    test "erases session and cookies", %{conn: conn, login: login} do
      login_token = Accounts.generate_login_session_token(login)

      conn =
        conn
        |> put_session(:login_token, login_token)
        |> put_req_cookie(@remember_me_cookie, login_token)
        |> fetch_cookies()
        |> LoginAuth.log_out_login()

      refute get_session(conn, :login_token)
      refute conn.cookies[@remember_me_cookie]
      assert %{max_age: 0} = conn.resp_cookies[@remember_me_cookie]
      assert redirected_to(conn) == ~p"/"
      refute Accounts.get_login_by_session_token(login_token)
    end

    test "broadcasts to the given live_socket_id", %{conn: conn} do
      live_socket_id = "logins_sessions:abcdef-token"
      Risk4Web.Endpoint.subscribe(live_socket_id)

      conn
      |> put_session(:live_socket_id, live_socket_id)
      |> LoginAuth.log_out_login()

      assert_receive %Phoenix.Socket.Broadcast{event: "disconnect", topic: ^live_socket_id}
    end

    test "works even if login is already logged out", %{conn: conn} do
      conn = conn |> fetch_cookies() |> LoginAuth.log_out_login()
      refute get_session(conn, :login_token)
      assert %{max_age: 0} = conn.resp_cookies[@remember_me_cookie]
      assert redirected_to(conn) == ~p"/"
    end
  end

  describe "fetch_current_login/2" do
    test "authenticates login from session", %{conn: conn, login: login} do
      login_token = Accounts.generate_login_session_token(login)
      conn = conn |> put_session(:login_token, login_token) |> LoginAuth.fetch_current_login([])
      assert conn.assigns.current_login.id == login.id
    end

    test "authenticates login from cookies", %{conn: conn, login: login} do
      logged_in_conn =
        conn |> fetch_cookies() |> LoginAuth.log_in_login(login, %{"remember_me" => "true"})

      login_token = logged_in_conn.cookies[@remember_me_cookie]
      %{value: signed_token} = logged_in_conn.resp_cookies[@remember_me_cookie]

      conn =
        conn
        |> put_req_cookie(@remember_me_cookie, signed_token)
        |> LoginAuth.fetch_current_login([])

      assert conn.assigns.current_login.id == login.id
      assert get_session(conn, :login_token) == login_token

      assert get_session(conn, :live_socket_id) ==
               "logins_sessions:#{Base.url_encode64(login_token)}"
    end

    test "does not authenticate if data is missing", %{conn: conn, login: login} do
      _ = Accounts.generate_login_session_token(login)
      conn = LoginAuth.fetch_current_login(conn, [])
      refute get_session(conn, :login_token)
      refute conn.assigns.current_login
    end
  end

  describe "on_mount: mount_current_login" do
    test "assigns current_login based on a valid login_token ", %{conn: conn, login: login} do
      login_token = Accounts.generate_login_session_token(login)
      session = conn |> put_session(:login_token, login_token) |> get_session()

      {:cont, updated_socket} =
        LoginAuth.on_mount(:mount_current_login, %{}, session, %LiveView.Socket{})

      assert updated_socket.assigns.current_login.id == login.id
    end

    test "assigns nil to current_login assign if there isn't a valid login_token ", %{conn: conn} do
      login_token = "invalid_token"
      session = conn |> put_session(:login_token, login_token) |> get_session()

      {:cont, updated_socket} =
        LoginAuth.on_mount(:mount_current_login, %{}, session, %LiveView.Socket{})

      assert updated_socket.assigns.current_login == nil
    end

    test "assigns nil to current_login assign if there isn't a login_token", %{conn: conn} do
      session = conn |> get_session()

      {:cont, updated_socket} =
        LoginAuth.on_mount(:mount_current_login, %{}, session, %LiveView.Socket{})

      assert updated_socket.assigns.current_login == nil
    end
  end

  describe "on_mount: ensure_authenticated" do
    test "authenticates current_login based on a valid login_token ", %{conn: conn, login: login} do
      login_token = Accounts.generate_login_session_token(login)
      session = conn |> put_session(:login_token, login_token) |> get_session()

      {:cont, updated_socket} =
        LoginAuth.on_mount(:ensure_authenticated, %{}, session, %LiveView.Socket{})

      assert updated_socket.assigns.current_login.id == login.id
    end

    test "redirects to login page if there isn't a valid login_token ", %{conn: conn} do
      login_token = "invalid_token"
      session = conn |> put_session(:login_token, login_token) |> get_session()

      socket = %LiveView.Socket{
        endpoint: Risk4Web.Endpoint,
        assigns: %{__changed__: %{}, flash: %{}}
      }

      {:halt, updated_socket} = LoginAuth.on_mount(:ensure_authenticated, %{}, session, socket)
      assert updated_socket.assigns.current_login == nil
    end

    test "redirects to login page if there isn't a login_token ", %{conn: conn} do
      session = conn |> get_session()

      socket = %LiveView.Socket{
        endpoint: Risk4Web.Endpoint,
        assigns: %{__changed__: %{}, flash: %{}}
      }

      {:halt, updated_socket} = LoginAuth.on_mount(:ensure_authenticated, %{}, session, socket)
      assert updated_socket.assigns.current_login == nil
    end
  end

  describe "on_mount: :redirect_if_login_is_authenticated" do
    test "redirects if there is an authenticated  login ", %{conn: conn, login: login} do
      login_token = Accounts.generate_login_session_token(login)
      session = conn |> put_session(:login_token, login_token) |> get_session()

      assert {:halt, _updated_socket} =
               LoginAuth.on_mount(
                 :redirect_if_login_is_authenticated,
                 %{},
                 session,
                 %LiveView.Socket{}
               )
    end

    test "Don't redirect is there is no authenticated login", %{conn: conn} do
      session = conn |> get_session()

      assert {:cont, _updated_socket} =
               LoginAuth.on_mount(
                 :redirect_if_login_is_authenticated,
                 %{},
                 session,
                 %LiveView.Socket{}
               )
    end
  end

  describe "redirect_if_login_is_authenticated/2" do
    test "redirects if login is authenticated", %{conn: conn, login: login} do
      conn = conn |> assign(:current_login, login) |> LoginAuth.redirect_if_login_is_authenticated([])
      assert conn.halted
      assert redirected_to(conn) == ~p"/"
    end

    test "does not redirect if login is not authenticated", %{conn: conn} do
      conn = LoginAuth.redirect_if_login_is_authenticated(conn, [])
      refute conn.halted
      refute conn.status
    end
  end

  describe "require_authenticated_login/2" do
    test "redirects if login is not authenticated", %{conn: conn} do
      conn = conn |> fetch_flash() |> LoginAuth.require_authenticated_login([])
      assert conn.halted

      assert redirected_to(conn) == ~p"/logins/log_in"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) ==
               "You must log in to access this page."
    end

    test "stores the path to redirect to on GET", %{conn: conn} do
      halted_conn =
        %{conn | path_info: ["foo"], query_string: ""}
        |> fetch_flash()
        |> LoginAuth.require_authenticated_login([])

      assert halted_conn.halted
      assert get_session(halted_conn, :login_return_to) == "/foo"

      halted_conn =
        %{conn | path_info: ["foo"], query_string: "bar=baz"}
        |> fetch_flash()
        |> LoginAuth.require_authenticated_login([])

      assert halted_conn.halted
      assert get_session(halted_conn, :login_return_to) == "/foo?bar=baz"

      halted_conn =
        %{conn | path_info: ["foo"], query_string: "bar", method: "POST"}
        |> fetch_flash()
        |> LoginAuth.require_authenticated_login([])

      assert halted_conn.halted
      refute get_session(halted_conn, :login_return_to)
    end

    test "does not redirect if login is authenticated", %{conn: conn, login: login} do
      conn = conn |> assign(:current_login, login) |> LoginAuth.require_authenticated_login([])
      refute conn.halted
      refute conn.status
    end
  end
end
