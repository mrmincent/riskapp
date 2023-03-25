defmodule Risk4.AssessmentTest do
  use Risk4.DataCase

  alias Risk4.Assessment

  describe "actions" do
    alias Risk4.Assessment.Action

    import Risk4.AssessmentFixtures

    @invalid_attrs %{description: nil, due_date: nil, title: nil}

    test "list_actions/0 returns all actions" do
      action = action_fixture()
      assert Assessment.list_actions() == [action]
    end

    test "get_action!/1 returns the action with given id" do
      action = action_fixture()
      assert Assessment.get_action!(action.id) == action
    end

    test "create_action/1 with valid data creates a action" do
      valid_attrs = %{description: "some description", due_date: ~D[2023-03-21], title: "some title"}

      assert {:ok, %Action{} = action} = Assessment.create_action(valid_attrs)
      assert action.description == "some description"
      assert action.due_date == ~D[2023-03-21]
      assert action.title == "some title"
    end

    test "create_action/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assessment.create_action(@invalid_attrs)
    end

    test "update_action/2 with valid data updates the action" do
      action = action_fixture()
      update_attrs = %{description: "some updated description", due_date: ~D[2023-03-22], title: "some updated title"}

      assert {:ok, %Action{} = action} = Assessment.update_action(action, update_attrs)
      assert action.description == "some updated description"
      assert action.due_date == ~D[2023-03-22]
      assert action.title == "some updated title"
    end

    test "update_action/2 with invalid data returns error changeset" do
      action = action_fixture()
      assert {:error, %Ecto.Changeset{}} = Assessment.update_action(action, @invalid_attrs)
      assert action == Assessment.get_action!(action.id)
    end

    test "delete_action/1 deletes the action" do
      action = action_fixture()
      assert {:ok, %Action{}} = Assessment.delete_action(action)
      assert_raise Ecto.NoResultsError, fn -> Assessment.get_action!(action.id) end
    end

    test "change_action/1 returns a action changeset" do
      action = action_fixture()
      assert %Ecto.Changeset{} = Assessment.change_action(action)
    end
  end

  describe "threats" do
    alias Risk4.Assessment.Threat

    import Risk4.AssessmentFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_threats/0 returns all threats" do
      threat = threat_fixture()
      assert Assessment.list_threats() == [threat]
    end

    test "get_threat!/1 returns the threat with given id" do
      threat = threat_fixture()
      assert Assessment.get_threat!(threat.id) == threat
    end

    test "create_threat/1 with valid data creates a threat" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Threat{} = threat} = Assessment.create_threat(valid_attrs)
      assert threat.description == "some description"
      assert threat.name == "some name"
    end

    test "create_threat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assessment.create_threat(@invalid_attrs)
    end

    test "update_threat/2 with valid data updates the threat" do
      threat = threat_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Threat{} = threat} = Assessment.update_threat(threat, update_attrs)
      assert threat.description == "some updated description"
      assert threat.name == "some updated name"
    end

    test "update_threat/2 with invalid data returns error changeset" do
      threat = threat_fixture()
      assert {:error, %Ecto.Changeset{}} = Assessment.update_threat(threat, @invalid_attrs)
      assert threat == Assessment.get_threat!(threat.id)
    end

    test "delete_threat/1 deletes the threat" do
      threat = threat_fixture()
      assert {:ok, %Threat{}} = Assessment.delete_threat(threat)
      assert_raise Ecto.NoResultsError, fn -> Assessment.get_threat!(threat.id) end
    end

    test "change_threat/1 returns a threat changeset" do
      threat = threat_fixture()
      assert %Ecto.Changeset{} = Assessment.change_threat(threat)
    end
  end

  describe "vulnerabilities" do
    alias Risk4.Assessment.Vulnerability

    import Risk4.AssessmentFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_vulnerabilities/0 returns all vulnerabilities" do
      vulnerability = vulnerability_fixture()
      assert Assessment.list_vulnerabilities() == [vulnerability]
    end

    test "get_vulnerability!/1 returns the vulnerability with given id" do
      vulnerability = vulnerability_fixture()
      assert Assessment.get_vulnerability!(vulnerability.id) == vulnerability
    end

    test "create_vulnerability/1 with valid data creates a vulnerability" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Vulnerability{} = vulnerability} = Assessment.create_vulnerability(valid_attrs)
      assert vulnerability.description == "some description"
      assert vulnerability.name == "some name"
    end

    test "create_vulnerability/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assessment.create_vulnerability(@invalid_attrs)
    end

    test "update_vulnerability/2 with valid data updates the vulnerability" do
      vulnerability = vulnerability_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Vulnerability{} = vulnerability} = Assessment.update_vulnerability(vulnerability, update_attrs)
      assert vulnerability.description == "some updated description"
      assert vulnerability.name == "some updated name"
    end

    test "update_vulnerability/2 with invalid data returns error changeset" do
      vulnerability = vulnerability_fixture()
      assert {:error, %Ecto.Changeset{}} = Assessment.update_vulnerability(vulnerability, @invalid_attrs)
      assert vulnerability == Assessment.get_vulnerability!(vulnerability.id)
    end

    test "delete_vulnerability/1 deletes the vulnerability" do
      vulnerability = vulnerability_fixture()
      assert {:ok, %Vulnerability{}} = Assessment.delete_vulnerability(vulnerability)
      assert_raise Ecto.NoResultsError, fn -> Assessment.get_vulnerability!(vulnerability.id) end
    end

    test "change_vulnerability/1 returns a vulnerability changeset" do
      vulnerability = vulnerability_fixture()
      assert %Ecto.Changeset{} = Assessment.change_vulnerability(vulnerability)
    end
  end

  describe "controls" do
    alias Risk4.Assessment.Control

    import Risk4.AssessmentFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_controls/0 returns all controls" do
      control = control_fixture()
      assert Assessment.list_controls() == [control]
    end

    test "get_control!/1 returns the control with given id" do
      control = control_fixture()
      assert Assessment.get_control!(control.id) == control
    end

    test "create_control/1 with valid data creates a control" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Control{} = control} = Assessment.create_control(valid_attrs)
      assert control.description == "some description"
      assert control.name == "some name"
    end

    test "create_control/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assessment.create_control(@invalid_attrs)
    end

    test "update_control/2 with valid data updates the control" do
      control = control_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Control{} = control} = Assessment.update_control(control, update_attrs)
      assert control.description == "some updated description"
      assert control.name == "some updated name"
    end

    test "update_control/2 with invalid data returns error changeset" do
      control = control_fixture()
      assert {:error, %Ecto.Changeset{}} = Assessment.update_control(control, @invalid_attrs)
      assert control == Assessment.get_control!(control.id)
    end

    test "delete_control/1 deletes the control" do
      control = control_fixture()
      assert {:ok, %Control{}} = Assessment.delete_control(control)
      assert_raise Ecto.NoResultsError, fn -> Assessment.get_control!(control.id) end
    end

    test "change_control/1 returns a control changeset" do
      control = control_fixture()
      assert %Ecto.Changeset{} = Assessment.change_control(control)
    end
  end

  describe "riskassessments" do
    alias Risk4.Assessment.RiskAssessment

    import Risk4.AssessmentFixtures

    @invalid_attrs %{consequences: nil, description: nil, due_date: nil, name: nil, postcontrol_impact: nil, postcontrol_likelihood: nil, postcontrol_risk: nil, precontrol_impact: nil, precontrol_likelihood: nil, precontrol_risk: nil, start_date: nil}

    test "list_riskassessments/0 returns all riskassessments" do
      risk_assessment = risk_assessment_fixture()
      assert Assessment.list_riskassessments() == [risk_assessment]
    end

    test "get_risk_assessment!/1 returns the risk_assessment with given id" do
      risk_assessment = risk_assessment_fixture()
      assert Assessment.get_risk_assessment!(risk_assessment.id) == risk_assessment
    end

    test "create_risk_assessment/1 with valid data creates a risk_assessment" do
      valid_attrs = %{consequences: "some consequences", description: "some description", due_date: ~D[2023-03-21], name: "some name", postcontrol_impact: 42, postcontrol_likelihood: 42, postcontrol_risk: 42, precontrol_impact: 42, precontrol_likelihood: 42, precontrol_risk: 42, start_date: ~D[2023-03-21]}

      assert {:ok, %RiskAssessment{} = risk_assessment} = Assessment.create_risk_assessment(valid_attrs)
      assert risk_assessment.consequences == "some consequences"
      assert risk_assessment.description == "some description"
      assert risk_assessment.due_date == ~D[2023-03-21]
      assert risk_assessment.name == "some name"
      assert risk_assessment.postcontrol_impact == 42
      assert risk_assessment.postcontrol_likelihood == 42
      assert risk_assessment.postcontrol_risk == 42
      assert risk_assessment.precontrol_impact == 42
      assert risk_assessment.precontrol_likelihood == 42
      assert risk_assessment.precontrol_risk == 42
      assert risk_assessment.start_date == ~D[2023-03-21]
    end

    test "create_risk_assessment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assessment.create_risk_assessment(@invalid_attrs)
    end

    test "update_risk_assessment/2 with valid data updates the risk_assessment" do
      risk_assessment = risk_assessment_fixture()
      update_attrs = %{consequences: "some updated consequences", description: "some updated description", due_date: ~D[2023-03-22], name: "some updated name", postcontrol_impact: 43, postcontrol_likelihood: 43, postcontrol_risk: 43, precontrol_impact: 43, precontrol_likelihood: 43, precontrol_risk: 43, start_date: ~D[2023-03-22]}

      assert {:ok, %RiskAssessment{} = risk_assessment} = Assessment.update_risk_assessment(risk_assessment, update_attrs)
      assert risk_assessment.consequences == "some updated consequences"
      assert risk_assessment.description == "some updated description"
      assert risk_assessment.due_date == ~D[2023-03-22]
      assert risk_assessment.name == "some updated name"
      assert risk_assessment.postcontrol_impact == 43
      assert risk_assessment.postcontrol_likelihood == 43
      assert risk_assessment.postcontrol_risk == 43
      assert risk_assessment.precontrol_impact == 43
      assert risk_assessment.precontrol_likelihood == 43
      assert risk_assessment.precontrol_risk == 43
      assert risk_assessment.start_date == ~D[2023-03-22]
    end

    test "update_risk_assessment/2 with invalid data returns error changeset" do
      risk_assessment = risk_assessment_fixture()
      assert {:error, %Ecto.Changeset{}} = Assessment.update_risk_assessment(risk_assessment, @invalid_attrs)
      assert risk_assessment == Assessment.get_risk_assessment!(risk_assessment.id)
    end

    test "delete_risk_assessment/1 deletes the risk_assessment" do
      risk_assessment = risk_assessment_fixture()
      assert {:ok, %RiskAssessment{}} = Assessment.delete_risk_assessment(risk_assessment)
      assert_raise Ecto.NoResultsError, fn -> Assessment.get_risk_assessment!(risk_assessment.id) end
    end

    test "change_risk_assessment/1 returns a risk_assessment changeset" do
      risk_assessment = risk_assessment_fixture()
      assert %Ecto.Changeset{} = Assessment.change_risk_assessment(risk_assessment)
    end
  end
end
