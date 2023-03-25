defmodule Risk4Web.CategoryHTML do
  use Risk4Web, :html

  embed_templates "category_html/*"

  @doc """
  Renders a category form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def category_form(assigns)
end
