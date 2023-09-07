require "test_helper"

class PortfoliosControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get portfolios_home_url
    assert_response :success
  end

  test "should get market" do
    get portfolios_market_url
    assert_response :success
  end

  test "should get portfolio" do
    get portfolios_portfolio_url
    assert_response :success
  end
end
