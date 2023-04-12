defmodule Risk4Web.RiskAssessmentHTML do
  use Risk4Web, :html

  embed_templates "risk_assessment_html/*"

  @doc """
  Renders a risk_assessment form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :threats, :any, default: []
  attr :threatlist, :any, default: []
  attr :controls, :any, default: []
  attr :controllist, :any, default: []
  attr :vulnerabilities, :any, default: []
  attr :vulnerabilitylist, :any, default: []
  attr :items, :any, default: []
  attr :itemslist, :any, default: []
  attr :displaymtx, :boolean, default: false

  def risk_assessment_form(assigns)
end
