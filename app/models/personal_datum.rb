class PersonalDatum < ApplicationRecord
    enum lawful_basis: [ :consent, :legitimate_interest, :further_processing, :statutory_requirement, :contractual_requirement, :vital_interest. :public_interest ]
end
