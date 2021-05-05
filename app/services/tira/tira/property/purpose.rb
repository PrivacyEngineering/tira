require 'ruby_yappl'

module Tira
    module Property

        class Purpose
            attr_reader :name,
                        :personal_data,
                        :services


            def initialize(name)
                @name = name
                @services = []
                @personal_data = []

            end

            def add_personal_datum(pd)
                @personal_data << pd
            end

            def add_service(service)
                @services << service unless @services.include? service
            end

            def to_s
                @name                
            end

        end
    end
end