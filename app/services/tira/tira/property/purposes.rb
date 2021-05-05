require 'ruby_yappl'

module Tira
    module Property

        class Purposes < Tira::Property::TransparencyProperty

            attr_reader :ruby_policy


            def initialize(open_api_values, personal_datum)
                @type = Tira::Property::PropertyType::PURPOSES
                
                @ruby_policy = parse_policy(open_api_values)

                super(open_api_values, personal_datum)
            end

            def validate
                begin
                    parse_policy
                rescue
                    return false
                end
            end

            def parse_policy(policy=nil)
                policy ||= @open_api_document_values
                JSON.parse(policy)
            end

            def yappl_policy
                YaPPL::Policy.from_policy_file(@open_api_document_values)
            end

            def get_permitted_purposes
                pps = []
                yappl_policy.get_tr_rules.first[:permitted_purposes].each do |purpose_name|
                    pps << Tira::Property::Purpose.new(purpose_name)
                end
                return pps
            end

        end
    end
end