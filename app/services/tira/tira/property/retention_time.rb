module Tira
    module Property

        class RetentionTime < Tira::Property::TransparencyProperty

            attr_reader :retention_timespan,
                        :periodic_review,
                        :review_frequency,
                        :depending_on_other_obligations,
                        :volatile


            def initialize(open_api_values, personal_datum)
                @type = Tira::Property::PropertyType::RETENTION_TIME


                super(open_api_values, personal_datum)
            end


            def volatile
                doc_value('volatile')
            end 

            def no_limit
                doc_value('no_limit')
            end

            def retention_timespan
                if volatile
                    return 0
                elsif no_limit
                    return -1
                else
                    years = doc_value('retention_timespan_years')
                    month = doc_value('retention_timespan_month')
                    days = doc_value('retention_timespan_days')
                    if years or month or days
                        days += month * 30 if month
                        days += years * 365 if years
                        return days
                    end
                end
                return nil
            end

        end
    end
end