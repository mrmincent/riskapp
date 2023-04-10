defmodule RiskInit do
  @moduledoc """
  RiskInit keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Risk4.Repo
  alias Risk4.Shared.Status


  def run do
    Repo.delete_all(Status)
    Status.create_status(%{name: "Active", description: "Active Status indicates the record is in use and progressing"})
    Status.create_status(%{name: "Inactive", description: "Inactive Status indicates the record is open but not progressing"})
    Status.create_status(%{name: "Overdue", description: "Overdue Status indicates the record is open and past it's due date"})
    Status.create_status(%{name: "Closed", description: "Closed Status indicates the record is no longer being worked on"})
    Status.create_status(%{name: "Complete", description: "Complete Status indicates the record is finalised and no longer being worked on"})
    Status.create_status(%{name: "Cancelled", description: "Cancelled Status indicates the record is not active and not used within the system"})
    Status.create_status(%{name: "New", description: "New Status indicates the record has been created but is not in use"})

  end


end
