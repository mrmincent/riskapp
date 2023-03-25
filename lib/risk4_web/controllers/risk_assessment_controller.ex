defmodule Risk4Web.RiskAssessmentController do
  use Risk4Web, :controller

  alias Risk4.Assessment
  alias Risk4.Assessment.RiskAssessment

  def index(conn, _params) do
    riskassessments = Assessment.list_riskassessments()
    render(conn, :index, riskassessments: riskassessments)
  end

  def new(conn, _params) do
    changeset = Assessment.change_risk_assessment(%RiskAssessment{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"risk_assessment" => risk_assessment_params}) do
    case Assessment.create_risk_assessment(risk_assessment_params) do
      {:ok, risk_assessment} ->
        conn
        |> put_flash(:info, "Risk assessment created successfully.")
        |> redirect(to: ~p"/riskassessments/#{risk_assessment}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    risk_assessment = Assessment.get_risk_assessment!(id)
    render(conn, :show, risk_assessment: risk_assessment)
  end

  def edit(conn, %{"id" => id}) do
    risk_assessment = Assessment.get_risk_assessment!(id)
    changeset = Assessment.change_risk_assessment(risk_assessment)
    render(conn, :edit, risk_assessment: risk_assessment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "risk_assessment" => risk_assessment_params}) do
    risk_assessment = Assessment.get_risk_assessment!(id)

    case Assessment.update_risk_assessment(risk_assessment, risk_assessment_params) do
      {:ok, risk_assessment} ->
        conn
        |> put_flash(:info, "Risk assessment updated successfully.")
        |> redirect(to: ~p"/riskassessments/#{risk_assessment}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, risk_assessment: risk_assessment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    risk_assessment = Assessment.get_risk_assessment!(id)
    {:ok, _risk_assessment} = Assessment.delete_risk_assessment(risk_assessment)

    conn
    |> put_flash(:info, "Risk assessment deleted successfully.")
    |> redirect(to: ~p"/riskassessments")
  end
end
