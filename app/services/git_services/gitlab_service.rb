module GitServices
  class GitlabService < AbstractGitService

    def initialize ()
      super()

      # @host += 'people/search'
    end

    def search(vorname: "", nachname: "", geburtsdatum: "", strasse: "", plz: "", ort: "")
      # stern (*) wäre ein platzhalter, das geht überall außer beim geburtsdatum.
      # wenn jemand einen platzhalter statt einfach freigelassenem feld will, soll das explizit gepasst werden

      resp = conn.get do |req|
        req.params['v'] = vorname
        req.params['n'] = nachname
        req.params['g'] = geburtsdatum
        req.params['s'] = strasse
        req.params['p'] = plz
        req.params['o'] = ort
      end
      if resp.body and r = JSON.parse(resp.body)
        return r
      end
      return false
    end

    def specific 
      self.class
    end
    
  end
end