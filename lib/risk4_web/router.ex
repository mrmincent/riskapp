defmodule Risk4Web.Router do
  use Risk4Web, :router

  import Risk4Web.LoginAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Risk4Web.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_login
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Risk4Web do
    pipe_through [:browser, :require_authenticated_login]

    get "/", PageController, :home
    resources "/statuses", StatusController
    resources "/categories", CategoryController
    resources "/asset_types", Asset_TypeController
    resources "/items", ItemController
    resources "/users", UserController
    resources "/actions", ActionController
    resources "/threats", ThreatController
    resources "/vulnerabilities", VulnerabilityController
    resources "/controls", ControlController
    resources "/riskassessments", RiskAssessmentController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Risk4Web do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:risk4, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:browser, :require_authenticated_login]

      live_dashboard "/dashboard", metrics: Risk4Web.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", Risk4Web do
    pipe_through [:browser, :redirect_if_login_is_authenticated]

    live_session :redirect_if_login_is_authenticated,
      on_mount: [{Risk4Web.LoginAuth, :redirect_if_login_is_authenticated}] do
      live "/logins/register", LoginRegistrationLive, :new
      live "/logins/log_in", LoginLoginLive, :new
      live "/logins/reset_password", LoginForgotPasswordLive, :new
      live "/logins/reset_password/:token", LoginResetPasswordLive, :edit
    end

    post "/logins/log_in", LoginSessionController, :create
  end

  scope "/", Risk4Web do
    pipe_through [:browser, :require_authenticated_login]

    live_session :require_authenticated_login,
      on_mount: [{Risk4Web.LoginAuth, :ensure_authenticated}] do
      live "/logins/settings", LoginSettingsLive, :edit
      live "/logins/settings/confirm_email/:token", LoginSettingsLive, :confirm_email
    end
  end

  scope "/", Risk4Web do
    pipe_through [:browser]

    delete "/logins/log_out", LoginSessionController, :delete

    live_session :current_login,
      on_mount: [{Risk4Web.LoginAuth, :mount_current_login}] do
      live "/logins/confirm/:token", LoginConfirmationLive, :edit
      live "/logins/confirm", LoginConfirmationInstructionsLive, :new
    end
  end
end
