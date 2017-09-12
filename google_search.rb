#!/usr/bin/env ruby

require "selenium-webdriver"
require "test/unit"

class GoogleSearch < Test::Unit::TestCase
  def setup
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "http://www.google.com/"
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end
  def test_google_search
    @driver.get(@base_url)
    @driver.find_element(:name, "q").clear
    @driver.find_element(:name, "q").send_keys "Olivia Veluchamy"
    @driver.find_element(:name, "btnG").click
    p @driver.find_element(:css => "div.g:nth-child(1) > div:nth-child(1) > div:nth-child(1) > div:nth-child(2) > div:nth-child(1) > span:nth-child(3) > em:nth-child(3)").text
    verify { assert(@driver.find_element(:css => "div.g:nth-child(1) > div:nth-child(1) > div:nth-child(1) > div:nth-child(2) > div:nth-child(1) > span:nth-child(3) > em:nth-child(3)").text.include?("Veluchamy"),"Page contains the text Veluchamy")}
  end
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
end
