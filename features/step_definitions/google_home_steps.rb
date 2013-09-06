Given /^I am the Google Homepage$/ do
  @google.browser.goto "www.google.com"
end

When /^I perform a search for "([^"]*)"$/ do |search_criteria|
  @search_criteria = search_criteria
  @google.home_page.search_field.set @search_criteria
  @google.home_page.search_button.click
end

Then /^I should see that the URL contains my search criterion$/ do
  @google.home_page.page_url_text.should include @search_criteria
end