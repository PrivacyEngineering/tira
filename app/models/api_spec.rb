class ApiSpec < ApplicationRecord
    belongs_to :service

    has_one_attached :open_api_specification

        MINIMAL_OPENAPI_HASH = {
            "openapi" => "3.0.0",
            "info" => {
                "title" => "Minimal Placeholder Spec",
                "version" => "1.0.0"
            },
            "paths" => {}
        }.freeze

    # validates :spec, presence: true


    def get_personal_data
        # @spec_service.get_schemas_from_path
        service = transparency_service
        return nil unless service
        service.consumed_personal_data
    end

    def transparency_service
        Tira::OpenApiServices::OpenApi3DocumentService.new(self.get_specification_file_content, self.service) if self.get_specification_file_content and self.service
    end

    def get_specification_file_content
        ensure_minimal_open_api_specification!
        return minimal_openapi_json unless self.open_api_specification.attached?

        file = File.open(ActiveStorage::Blob.service.send(:path_for, self.open_api_specification.key))
        data = File.read(file)
        return minimal_openapi_json if data.blank?

        case self.open_api_specification.content_type
            when "application/x-yaml", "text/yaml", "application/yaml", "text/x-yaml"
                parsed = YAML.safe_load(data, permitted_classes: [Symbol], aliases: true)
                return minimal_openapi_json if parsed.blank?
                return parsed.to_json
            when "application/json", "text/json"
                # ##############################
                # TODO Validate JSON
                #
                # (probably at another place (on upload), but has to be done before here)
                # ##############################

                # Ensure JSON is valid before returning.
                return JSON.parse(data).to_json
        else
            return minimal_openapi_json
        end
    rescue Psych::Exception, JSON::ParserError
        minimal_openapi_json
    end

    private

    def ensure_minimal_open_api_specification!
        return unless persisted?
        return if self.open_api_specification.attached?

        self.open_api_specification.attach(
          io: StringIO.new(minimal_openapi_yaml),
          filename: "minimal_open_api_spec.yml",
          content_type: "application/x-yaml"
        )
    rescue StandardError => e
        Rails.logger.warn("ApiSpec##{id}: could not attach minimal OpenAPI spec: #{e.message}")
    end

    def minimal_openapi_json
        MINIMAL_OPENAPI_HASH.to_json
    end

    def minimal_openapi_yaml
        MINIMAL_OPENAPI_HASH.to_yaml
    end

end
