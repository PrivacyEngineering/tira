module GitServices
  class AbstractGitService

    attr_accessor :host

    def initialize ()
      # @host = ENV['IWM_URL'] + '/IWM/'
      @error = nil
    end

    def conn
      # Faraday.new(
      #   url: 'https://' + @host,
      #   headers: {'Content-Type' => 'application/json; charset=UTF-8'},
      #   :ssl => {
      #     verify: false
      #     # :client_cert  => ...,
      #     # :client_key   => ...,
      #     # :ca_file      => ...,
      #     # :ca_path      => ...,
      #     # :cert_store   => ...
      #   }
      # ) 
    end


    def test
      # conn.get('/')
      "Actract Git Service speaking"
    end

    def specific
      raise 'this method should be overriden by a specific git service'
    end

  end
end