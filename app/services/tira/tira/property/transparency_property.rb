module Tira
    module Property

        class TransparencyProperty

            attr_accessor   :type,
                            :open_api_document_values,
                            :personal_datum


            def initialize(open_api_values, personal_datum)
                @open_api_document_values = open_api_values
                @personal_datum = personal_datum
            end



            def doc_value(key)
                begin
                    @open_api_document_values[key]
                rescue
                    return nil
                end
                # return nil
            end
            

        end
    end
end