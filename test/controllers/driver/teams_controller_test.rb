require "test_helper"

class Driver::TeamsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get driver_teams_url
    assert_response :success
    assert_select "h1", "Teams"
  end

  test "should get show" do
    team = create(:team)
    get driver_team_url(team)
    assert_response :success
  end
end
