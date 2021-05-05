module Tira
    class AbstractOpenApiDocumentService < Openapi3Parser::Document

        def consumed_personal_data
            raise 'not implemented'
        end

        def exposed_personal_data
            raise 'not implemented'
        end


    end
end