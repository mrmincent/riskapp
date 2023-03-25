defmodule Risk4Web.StatusHTML do
  use Risk4Web, :html

  embed_templates "status_html/*"

  @doc """
  Renders a status form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def status_form(assigns)
end
