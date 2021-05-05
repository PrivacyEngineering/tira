require 'ruby_yappl'

module Tira
    module Property

        class ThirdCountryTransfer < Tira::Property::TransparencyProperty


            def initialize(open_api_values)
                @type = Tira::Property::PropertyType::THIRD_COUNTRY_TRANSFER
                @services = []
                @personal_data = []
                super(open_api_values, nil)
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

            def add_personal_datum(pd)
                @personal_data << pd
            end

            def add_service(service)
                @services << service unless @services.include? service
            end

            def to_s   
            end

        end
    end
end