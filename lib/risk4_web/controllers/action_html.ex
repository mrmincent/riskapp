defmodule Risk4Web.ActionHTML do
  use Risk4Web, :html

  embed_templates "action_html/*"

  @doc """
  Renders a action form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def action_form(assigns)
end
