defmodule Risk4Web.RiskAssessmentControllerTest do
  use Risk4Web.ConnCase

  import Risk4.AssessmentFixtures

  @create_attrs %{consequences: "some consequences", description: "some description", due_date: ~D[2023-03-21], name: "some name", postcontrol_impact: 42, postcontrol_likelihood: 42, postcontrol_risk: 42, precontrol_impact: 42, precontrol_likelihood: 42, precontrol_risk: 42, start_date: ~D[2023-03-21]}
  @update_attrs %{consequences: "some updated consequences", description: "some updated description", due_date: ~D[2023-03-22], name: "some updated name", postcontrol_impact: 43, postcontrol_likelihood: 43, postcontrol_risk: 43, precontrol_impact: 43, precontrol_likelihood: 43, precontrol_risk: 43, start_date: ~D[2023-03-22]}
  @invalid_attrs %{consequences: nil, description: nil, due_date: nil, name: nil, postcontrol_impact: nil, postcontrol_likelihood: nil, postcontrol_risk: nil, precontrol_impact: nil, precontrol_likelihood: nil, precontrol_risk: nil, start_date: nil}

  describe "index" do
    test "lists all riskassessments", %{conn: conn} do
      conn = get(conn, ~p"/riskassessments")
      assert html_response(conn, 200) =~ "Listing Riskassessments"
    end
  end

  describe "new risk_assessment" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/riskassessments/new")
      assert html_response(conn, 200) =~ "New Risk assessment"
    end
  end

  describe "create risk_assessment" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/riskassessments", risk_assessment: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/riskassessments/#{id}"

      conn = get(conn, ~p"/riskassessments/#{id}")
      assert html_response(conn, 200) =~ "Risk assessment #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/riskassessments", risk_assessment: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Risk assessment"
    end
  end

  describe "edit risk_assessment" do
    setup [:create_risk_assessment]

    test "renders form for editing chosen risk_assessment", %{conn: conn, risk_assessment: risk_assessment} do
      conn = get(conn, ~p"/riskassessments/#{risk_assessment}/edit")
      assert html_response(conn, 200) =~ "Edit Risk assessment"
    end
  end

  describe "update risk_assessment" do
    setup [:create_risk_assessment]

    test "redirects when data is valid", %{conn: conn, risk_assessment: risk_assessment} do
      conn = put(conn, ~p"/riskassessments/#{risk_assessment}", risk_assessment: @update_attrs)
      assert redirected_to(conn) == ~p"/riskassessments/#{risk_assessment}"

      conn = get(conn, ~p"/riskassessments/#{risk_assessment}")
      assert html_response(conn, 200) =~ "some updated consequences"
    end

    test "renders errors when data is invalid", %{conn: conn, risk_assessment: risk_assessment} do
      conn = put(conn, ~p"/riskassessments/#{risk_assessment}", risk_assessment: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Risk assessment"
    end
  end

  describe "delete risk_assessment" do
    setup [:create_risk_assessment]

    test "deletes chosen risk_assessment", %{conn: conn, risk_assessment: risk_assessment} do
      conn = delete(conn, ~p"/riskassessments/#{risk_assessment}")
      assert redirected_to(conn) == ~p"/riskassessments"

      assert_error_sent 404, fn ->
        get(conn, ~p"/riskassessments/#{risk_assessment}")
      end
    end
  end

  defp create_risk_assessment(_) do
    risk_assessment = risk_assessment_fixture()
    %{risk_assessment: risk_assessment}
  end
end
