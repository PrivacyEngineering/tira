class ServiceConnection < ApplicationRecord
    enum direction: [ :a_to_b, :b_to_a, :bidirectional ]

    belongs_to :service
    belongs_to :sender, :class_name => "Service"

end
