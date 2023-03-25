defmodule Risk4Web.RiskAssessmentHTML do
  use Risk4Web, :html

  embed_templates "risk_assessment_html/*"

  @doc """
  Renders a risk_assessment form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def risk_assessment_form(assigns)
end
