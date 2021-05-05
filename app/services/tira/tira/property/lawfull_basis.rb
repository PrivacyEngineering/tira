module Tira
    module Property

        class LawfullBasis < Tira::Property::TransparencyProperty

            attr_accessor   :based_on_consent


            def initialize(open_api_values)
                @type = Tira::Property::PropertyType::LAWFUL_BASIS


                super(open_api_values)
            end



            

        end
    end
end