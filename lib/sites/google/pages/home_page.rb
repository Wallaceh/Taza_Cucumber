require 'rubygems'
require 'taza/page'

module Google
  class HomePage < ::Taza::Page

    element(:search_field )  { browser.text_field(:id => "gbqfq" )}
    element(:search_button)  { browser.button(:id => "gbqfb" )}
    element(:site_url)  { browser.url}

    def page_url_text
      site_url.scan(/\w+/).join(" ")
    end

  end
end
