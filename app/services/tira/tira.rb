module Tira
    # first oad other modules / abstract classes
    require_relative 'tira/personal_datum'
    require_relative 'tira/abstract_open_api_document_service'
    require_relative 'tira/property/transparency_property'

    # then load all rb files
    Dir.glob(File.join(__dir__, "tira", "**", "*.rb")).each do |file|
      require file
    end
  
end