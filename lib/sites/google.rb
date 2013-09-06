require 'rubygems'
require 'taza'

module Google
  include ForwardInitialization

  class Google < ::Taza::Site

    def close
      browser.close
    end

  end
end
