defmodule Risk4.Assessment do
  @moduledoc """
  The Assessment context.
  """

  import Ecto.Query, warn: false
  alias Risk4.Repo

  alias Risk4.Assessment.Action

  @doc """
  Returns the list of actions.

  ## Examples

      iex> list_actions()
      [%Action{}, ...]

  """
  def list_actions do
    Repo.all(Action)
  end

  @doc """
  Gets a single action.

  Raises `Ecto.NoResultsError` if the Action does not exist.

  ## Examples

      iex> get_action!(123)
      %Action{}

      iex> get_action!(456)
      ** (Ecto.NoResultsError)

  """
  def get_action!(id), do: Repo.get!(Action, id)

  @doc """
  Creates a action.

  ## Examples

      iex> create_action(%{field: value})
      {:ok, %Action{}}

      iex> create_action(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_action(attrs \\ %{}) do
    %Action{}
    |> Action.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a action.

  ## Examples

      iex> update_action(action, %{field: new_value})
      {:ok, %Action{}}

      iex> update_action(action, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_action(%Action{} = action, attrs) do
    action
    |> Action.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a action.

  ## Examples

      iex> delete_action(action)
      {:ok, %Action{}}

      iex> delete_action(action)
      {:error, %Ecto.Changeset{}}

  """
  def delete_action(%Action{} = action) do
    Repo.delete(action)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking action changes.

  ## Examples

      iex> change_action(action)
      %Ecto.Changeset{data: %Action{}}

  """
  def change_action(%Action{} = action, attrs \\ %{}) do
    Action.changeset(action, attrs)
  end

  alias Risk4.Assessment.Threat

  @doc """
  Returns the list of threats.

  ## Examples

      iex> list_threats()
      [%Threat{}, ...]

  """
  def list_threats do
    Repo.all(Threat)
  end

  @doc """
  Gets a single threat.

  Raises `Ecto.NoResultsError` if the Threat does not exist.

  ## Examples

      iex> get_threat!(123)
      %Threat{}

      iex> get_threat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_threat!(id), do: Repo.get!(Threat, id)

  @doc """
  Creates a threat.

  ## Examples

      iex> create_threat(%{field: value})
      {:ok, %Threat{}}

      iex> create_threat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_threat(attrs \\ %{}) do
    %Threat{}
    |> Threat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a threat.

  ## Examples

      iex> update_threat(threat, %{field: new_value})
      {:ok, %Threat{}}

      iex> update_threat(threat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_threat(%Threat{} = threat, attrs) do
    threat
    |> Threat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a threat.

  ## Examples

      iex> delete_threat(threat)
      {:ok, %Threat{}}

      iex> delete_threat(threat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_threat(%Threat{} = threat) do
    Repo.delete(threat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking threat changes.

  ## Examples

      iex> change_threat(threat)
      %Ecto.Changeset{data: %Threat{}}

  """
  def change_threat(%Threat{} = threat, attrs \\ %{}) do
    Threat.changeset(threat, attrs)
  end

  alias Risk4.Assessment.Vulnerability

  @doc """
  Returns the list of vulnerabilities.

  ## Examples

      iex> list_vulnerabilities()
      [%Vulnerability{}, ...]

  """
  def list_vulnerabilities do
    Repo.all(Vulnerability)
  end

  @doc """
  Gets a single vulnerability.

  Raises `Ecto.NoResultsError` if the Vulnerability does not exist.

  ## Examples

      iex> get_vulnerability!(123)
      %Vulnerability{}

      iex> get_vulnerability!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vulnerability!(id), do: Repo.get!(Vulnerability, id)

  @doc """
  Creates a vulnerability.

  ## Examples

      iex> create_vulnerability(%{field: value})
      {:ok, %Vulnerability{}}

      iex> create_vulnerability(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vulnerability(attrs \\ %{}) do
    %Vulnerability{}
    |> Vulnerability.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a vulnerability.

  ## Examples

      iex> update_vulnerability(vulnerability, %{field: new_value})
      {:ok, %Vulnerability{}}

      iex> update_vulnerability(vulnerability, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vulnerability(%Vulnerability{} = vulnerability, attrs) do
    vulnerability
    |> Vulnerability.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a vulnerability.

  ## Examples

      iex> delete_vulnerability(vulnerability)
      {:ok, %Vulnerability{}}

      iex> delete_vulnerability(vulnerability)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vulnerability(%Vulnerability{} = vulnerability) do
    Repo.delete(vulnerability)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vulnerability changes.

  ## Examples

      iex> change_vulnerability(vulnerability)
      %Ecto.Changeset{data: %Vulnerability{}}

  """
  def change_vulnerability(%Vulnerability{} = vulnerability, attrs \\ %{}) do
    Vulnerability.changeset(vulnerability, attrs)
  end

  alias Risk4.Assessment.Control

  @doc """
  Returns the list of controls.

  ## Examples

      iex> list_controls()
      [%Control{}, ...]

  """
  def list_controls do
    Repo.all(Control)
  end

  @doc """
  Gets a single control.

  Raises `Ecto.NoResultsError` if the Control does not exist.

  ## Examples

      iex> get_control!(123)
      %Control{}

      iex> get_control!(456)
      ** (Ecto.NoResultsError)

  """
  def get_control!(id), do: Repo.get!(Control, id)

  @doc """
  Creates a control.

  ## Examples

      iex> create_control(%{field: value})
      {:ok, %Control{}}

      iex> create_control(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_control(attrs \\ %{}) do
    %Control{}
    |> Control.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a control.

  ## Examples

      iex> update_control(control, %{field: new_value})
      {:ok, %Control{}}

      iex> update_control(control, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_control(%Control{} = control, attrs) do
    control
    |> Control.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a control.

  ## Examples

      iex> delete_control(control)
      {:ok, %Control{}}

      iex> delete_control(control)
      {:error, %Ecto.Changeset{}}

  """
  def delete_control(%Control{} = control) do
    Repo.delete(control)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking control changes.

  ## Examples

      iex> change_control(control)
      %Ecto.Changeset{data: %Control{}}

  """
  def change_control(%Control{} = control, attrs \\ %{}) do
    Control.changeset(control, attrs)
  end

  alias Risk4.Assessment.RiskAssessment

  @doc """
  Returns the list of riskassessments.

  ## Examples

      iex> list_riskassessments()
      [%RiskAssessment{}, ...]

  """
  def list_riskassessments do
    Repo.all(RiskAssessment)
  end

  @doc """
  Gets a single risk_assessment.

  Raises `Ecto.NoResultsError` if the Risk assessment does not exist.

  ## Examples

      iex> get_risk_assessment!(123)
      %RiskAssessment{}

      iex> get_risk_assessment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_risk_assessment!(id), do: Repo.get!(RiskAssessment, id)

  @doc """
  Creates a risk_assessment.

  ## Examples

      iex> create_risk_assessment(%{field: value})
      {:ok, %RiskAssessment{}}

      iex> create_risk_assessment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_risk_assessment(attrs \\ %{}) do
    %RiskAssessment{}
    |> RiskAssessment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a risk_assessment.

  ## Examples

      iex> update_risk_assessment(risk_assessment, %{field: new_value})
      {:ok, %RiskAssessment{}}

      iex> update_risk_assessment(risk_assessment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_risk_assessment(%RiskAssessment{} = risk_assessment, attrs) do
    threats = Map.get(attrs, "threat_ids", [])
    |> Enum.map(&Repo.get(Threat, &1))
    |> Enum.reject(&is_nil/1)
    IO.puts("############ update risk assessment #########")
    attrs = Map.put(attrs, "threats", threats)
    #risk_assessment
    #|> RiskAssessment.changeset(attrs)
    #|> Repo.update()

    changeset = change_risk_assessment(risk_assessment, attrs)
    IO.inspect(changeset)

    case Repo.update(changeset) do
      {:ok, risk_assessment} -> {:ok, Repo.preload(risk_assessment, :threats)}
      {:error, _} = error -> error
    end
  end

  @doc """
  Deletes a risk_assessment.

  ## Examples

      iex> delete_risk_assessment(risk_assessment)
      {:ok, %RiskAssessment{}}

      iex> delete_risk_assessment(risk_assessment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_risk_assessment(%RiskAssessment{} = risk_assessment) do
    Repo.delete(risk_assessment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking risk_assessment changes.

  ## Examples

      iex> change_risk_assessment(risk_assessment)
      %Ecto.Changeset{data: %RiskAssessment{}}

  """
  def change_risk_assessment(%RiskAssessment{} = risk_assessment, attrs \\ %{}) do
    RiskAssessment.changeset(risk_assessment, attrs)
  end
end
