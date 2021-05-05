class Service < ApplicationRecord
    # belongs_to :service_provider
    has_many :api_specs

    has_many :service_connections
    has_many :senders, through: :service_connections

    has_many :receiving_connections, foreign_key: :sender_id, class_name: "ServiceConnection"
    has_many :receivers, through: :receiving_connections, source: :service

    def transparency_service
        Tira::OpenApiServices::OpenApi3ServiceService.new(self)
    end

    def get_spec
        if api_spec = self.api_specs.last
            return api_spec.get_specification_file_content
        end
        return nil
    end

    def api_spec
        self.api_specs.last
    end

    def repo_directory
        Rails.root + 'data/git_repos/' + self.name
    end

end
