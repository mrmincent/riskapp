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
    risk_assessment = %RiskAssessment{}
    |> Risk4.Repo.preload(:threats)
    |> Risk4.Repo.preload(:controls)
    |> Risk4.Repo.preload(:vulnerabilities)
    |> Risk4.Repo.preload(:items)
    statuses = Risk4.Repo.all(Risk4.Shared.Status) # Fetch the list of statuses
    users = Risk4.Repo.all(Risk4.Shared.User) # Fetch the list of users
    threat_list = Risk4.Repo.all(Risk4.Assessment.Threat)
    controls_list = Risk4.Repo.all(Risk4.Assessment.Threat)
    vulnerabilities_list = Risk4.Repo.all(Risk4.Assessment.Threat)
    items_list = Risk4.Repo.all(Risk4.Asset.Item)
    #threats = risk_assessment.threats

    render(conn, :new, changeset: changeset, statuses: statuses, users: users,
      threats: risk_assessment.threats,
      vulnerabilities: risk_assessment.vulnerabilities,
      controls: risk_assessment.controls,
      threatlist: threat_list, vulnerabilitylist: vulnerabilities_list,
      controllist: controls_list, items: risk_assessment.items,
      itemslist: items_list
    )
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
    |> Risk4.Repo.preload([:threats, :controls, :vulnerabilities, :items])
    #threat_list = Risk4.Repo.all(Risk4.Assessment.Threat)
    #controls_list = Risk4.Repo.all(Risk4.Assessment.Control)
    #vulnerabilities_list = Risk4.Repo.all(Risk4.Assessment.Vulnerability)
    #items_list = Risk4.Repo.all(Risk4.Asset.Item)

    render(conn, :show, risk_assessment: risk_assessment,
      threats: risk_assessment.threats,
      controls: risk_assessment.controls,
      vulnerabilities: risk_assessment.vulnerabilities,
      items: risk_assessment.items)
  end

  def edit(conn, %{"id" => id}) do
    risk_assessment = Assessment.get_risk_assessment!(id)
    |> Risk4.Repo.preload(:threats)
    |> Risk4.Repo.preload(:controls)
    |> Risk4.Repo.preload(:vulnerabilities)
    |> Risk4.Repo.preload(:items)
    changeset = Assessment.change_risk_assessment(risk_assessment)
    IO.puts("edit changeset")
    IO.inspect(changeset)
    statuses = Risk4.Repo.all(Risk4.Shared.Status) # Fetch the list of statuses
    users = Risk4.Repo.all(Risk4.Shared.User) # Fetch the list of users
    threat_list = Risk4.Repo.all(Risk4.Assessment.Threat)
    controls_list = Risk4.Repo.all(Risk4.Assessment.Control)
    vulnerabilities_list = Risk4.Repo.all(Risk4.Assessment.Vulnerability)
    items_list = Risk4.Repo.all(Risk4.Asset.Item)
    #|> Enum.map(fn threat -> {threat.name, threat.id} end)
    #threat_list = Risk4.Repo.all(Risk4.Assessment.Threat)
    render(conn, :edit, risk_assessment: risk_assessment, changeset: changeset,
      statuses: statuses, users: users, threats: risk_assessment.threats,
      threatlist: threat_list, controls: risk_assessment.controls,
      controllist: controls_list, vulnerabilities: risk_assessment.vulnerabilities,
      vulnerabilitylist: vulnerabilities_list, items: risk_assessment.items, itemslist: items_list)
  end

  def update(conn, %{"id" => id, "risk_assessment" => risk_assessment_params}) do
    risk_assessment = Assessment.get_risk_assessment!(id)
    |> Risk4.Repo.preload([:threats, :controls, :vulnerabilities, :items]) # Preload the :threats association
    IO.puts("####RAC_UPDATE####")
    IO.inspect(risk_assessment_params)


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
