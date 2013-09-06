module Taza
  class Browser
    def self.create_watir_webdriver(params)
      require 'watir-webdriver'
      browser = nil
      if ENV['BROWSER'] == 'chrome'
        browser = Watir::Browser.new params[:browser]
                                     #:switches => [params[:switches]]
      elsif ENV['BROWSER'] == 'ie'
        browser = Watir::Browser.new params[:browser]
      elsif ENV['BROWSER'] == 'grid_ie'
        caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer(:version => params[:ie_version],
                                                                           :platform => params[:browser_platform])
        driver = Selenium::WebDriver.for(:remote,
                                         :url => params[:hub_url],
                                         :desired_capabilities => caps)
        browser = Watir::Browser.new driver
      elsif ENV['BROWSER'] == 'grid_chrome'
        caps = Selenium::WebDriver::Remote::Capabilities.chrome(:switches => [params[:switches]],
                                                                :version => params[:chrome_version],
                                                                :platform => params[:browser_platform])
        driver = Selenium::WebDriver.for(:remote,
                                         :url => params[:hub_url],
                                         :desired_capabilities => caps)
        browser = Watir::Browser.new driver
      elsif ENV['BROWSER'] == 'grid_firefox'
        client = Selenium::WebDriver::Remote::Http::Default.new
        client.timeout = 180 # seconds – default is 60
        profile = Selenium::WebDriver::Firefox::Profile.new
        # prevent Firefox from attempting www.X.com whenever X cannot be found
        # disable "domain guessing" http://www-archive.mozilla.org/docs/end-user/domain-guessing.html
        # http://code.google.com/p/selenium/wiki/RubyBindings#Tweaking_Firefox_preferences
        profile['browser.fixup.alternate.enabled'] = false
        # prevents the "Firefox can't find the server at X" message
        # http://newsnorthwoods.blogspot.com/2010/07/firefox-fix-for-server-not-found-error.html
        profile['network.dns.disablePrefetch'] = true
        profile['network.http.connect.timeout'] = 120 # These are attempts to increase the timeout before failing to find a site
        profile['network.http.request.timeout'] = 120 #  NOTE: they don't appear to affect our failures.

        caps = Selenium::WebDriver::Remote::Capabilities.firefox(:firefox_profile => profile,
                                                                 :version => params[:firefox_version],
                                                                 :platform => params[:browser_platform])
        driver = Selenium::WebDriver.for(:remote,
                                         :url => params[:hub_url],
                                         :desired_capabilities => caps,
                                         :http_client => client)
        #driver.manage.timeouts.page_load = 120
        browser = Watir::Browser.new driver

      elsif ENV['BROWSER'] == 'firefox'
        profile = add_firefox_download_directory(params[:profile])
        profile.add_extension File.expand_path("../../../../google/tools/extensions/firebug-1.11.2.xpi", __FILE__)
        profile.add_extension File.expand_path("../../../../google/tools/extensions/JSErrorCollector.xpi", __FILE__)
        profile['extensions.firebug.currentVersion'] = "1.9.2"
        browser = Watir::Browser.new params[:browser], :profile => profile
      else
        browser = Watir::Browser.new params[:browser]
      end
      browser
    end

    def self.add_chrome_download_directory(profile)
      custom_profile = profile.nil? ? Selenium::WebDriver::Chrome::Profile.new : profile
      custom_profile["download.default_directory"] = custom_profile["download.default_directory"] rescue File.expand_path("../onyx-automation/temp")
      custom_profile["download.prompt_for_download"] = false
      custom_profile
    end

    def self.add_firefox_download_directory(profile)
      download_directory = "../onyx-automation/temp"
      download_directory.gsub!("/", "\\") if Selenium::WebDriver::Platform.windows?
      custom_profile = profile.nil? ? Selenium::WebDriver::Firefox::Profile.new : profile
      custom_profile['browser.download.folderList'] = 2 # custom location
      custom_profile['browser.download.dir'] = download_directory
      custom_profile['browser.helperApps.neverAsk.saveToDisk'] = "text/csv,application/pdf"
      custom_profile
    end

  end
end

