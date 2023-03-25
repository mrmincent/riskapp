defmodule Risk4Web.ControlHTML do
  use Risk4Web, :html

  embed_templates "control_html/*"

  @doc """
  Renders a control form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def control_form(assigns)
end
