module Tira
  # module Node
    ## 
    # This class ...
    # 
    module Property
        class UtilizerCategory < Tira::Property::TransparencyProperty


            attr_accessor   :non_eu_country

            def initialize(open_api_values, personal_datum)
                @type = Tira::Property::PropertyType::UTILIZER_CATEGORY

                super(open_api_values, personal_datum)
            end


            def name
                open_api_document_values["name"] if open_api_document_values["name"]
            end

            def non_eu?
                if open_api_document_values["non_eu_country"]
                    return open_api_document_values["non_eu_country"] == true
                end
            end
            
            def country
                if open_api_document_values["country"]
                    return open_api_document_values["country"]
                end
            end


        end
    end
end