defmodule Risk4Web.Router do
  use Risk4Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Risk4Web.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Risk4Web do
    pipe_through :browser

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
      pipe_through :browser

      live_dashboard "/dashboard", metrics: Risk4Web.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
