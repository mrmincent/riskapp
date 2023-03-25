defmodule Risk4Web.ThreatController do
  use Risk4Web, :controller

  alias Risk4.Assessment
  alias Risk4.Assessment.Threat

  def index(conn, _params) do
    threats = Assessment.list_threats()
    render(conn, :index, threats: threats)
  end

  def new(conn, _params) do
    changeset = Assessment.change_threat(%Threat{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"threat" => threat_params}) do
    case Assessment.create_threat(threat_params) do
      {:ok, threat} ->
        conn
        |> put_flash(:info, "Threat created successfully.")
        |> redirect(to: ~p"/threats/#{threat}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    threat = Assessment.get_threat!(id)
    render(conn, :show, threat: threat)
  end

  def edit(conn, %{"id" => id}) do
    threat = Assessment.get_threat!(id)
    changeset = Assessment.change_threat(threat)
    render(conn, :edit, threat: threat, changeset: changeset)
  end

  def update(conn, %{"id" => id, "threat" => threat_params}) do
    threat = Assessment.get_threat!(id)

    case Assessment.update_threat(threat, threat_params) do
      {:ok, threat} ->
        conn
        |> put_flash(:info, "Threat updated successfully.")
        |> redirect(to: ~p"/threats/#{threat}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, threat: threat, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    threat = Assessment.get_threat!(id)
    {:ok, _threat} = Assessment.delete_threat(threat)

    conn
    |> put_flash(:info, "Threat deleted successfully.")
    |> redirect(to: ~p"/threats")
  end
end
