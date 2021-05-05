module Tira
    module Property
        class PropertyType
            include Ruby::Enum

            define :LAWFUL_BASIS, "lawful_basis"
            define :RETENTION_TIME, "retention_time"
            define :PURPOSES, "purposes"
            define :PURPOSE, "purpose"
            define :UTILIZER, "utilizer"
            define :UTILIZER_CATEGORY, "utilizer_category"
            define :THIRD_COUNTRY_TRANSFER, "third_country_transfer"

        end
    end
end