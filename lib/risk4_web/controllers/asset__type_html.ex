defmodule Risk4Web.Asset_TypeHTML do
  use Risk4Web, :html

  embed_templates "asset__type_html/*"

  @doc """
  Renders a asset__type form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def asset__type_form(assigns)
end
