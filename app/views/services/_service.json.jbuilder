json.extract! service, :id, :name, :gitlab_repo, :internal, :service_provider_id, :created_at, :updated_at
json.url service_url(service, format: :json)
