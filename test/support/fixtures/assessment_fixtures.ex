defmodule Risk4.AssessmentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Risk4.Assessment` context.
  """

  @doc """
  Generate a action.
  """
  def action_fixture(attrs \\ %{}) do
    {:ok, action} =
      attrs
      |> Enum.into(%{
        description: "some description",
        due_date: ~D[2023-03-21],
        title: "some title"
      })
      |> Risk4.Assessment.create_action()

    action
  end

  @doc """
  Generate a threat.
  """
  def threat_fixture(attrs \\ %{}) do
    {:ok, threat} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Risk4.Assessment.create_threat()

    threat
  end

  @doc """
  Generate a vulnerability.
  """
  def vulnerability_fixture(attrs \\ %{}) do
    {:ok, vulnerability} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Risk4.Assessment.create_vulnerability()

    vulnerability
  end

  @doc """
  Generate a control.
  """
  def control_fixture(attrs \\ %{}) do
    {:ok, control} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Risk4.Assessment.create_control()

    control
  end

  @doc """
  Generate a risk_assessment.
  """
  def risk_assessment_fixture(attrs \\ %{}) do
    {:ok, risk_assessment} =
      attrs
      |> Enum.into(%{
        consequences: "some consequences",
        description: "some description",
        due_date: ~D[2023-03-21],
        name: "some name",
        postcontrol_impact: 42,
        postcontrol_likelihood: 42,
        postcontrol_risk: 42,
        precontrol_impact: 42,
        precontrol_likelihood: 42,
        precontrol_risk: 42,
        start_date: ~D[2023-03-21]
      })
      |> Risk4.Assessment.create_risk_assessment()

    risk_assessment
  end
end
