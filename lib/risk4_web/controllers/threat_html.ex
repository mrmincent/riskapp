defmodule Risk4Web.ThreatHTML do
  use Risk4Web, :html

  embed_templates "threat_html/*"

  @doc """
  Renders a threat form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def threat_form(assigns)
end
