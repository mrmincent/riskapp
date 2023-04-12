defmodule Risk4Web.PageController do
  use Risk4Web, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.


    risk_assessments = Risk4.Assessment.list_active_riskassessments()
    render(conn, :home, riskassessments: risk_assessments)
  end
end
