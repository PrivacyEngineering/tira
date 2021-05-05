Rails.application.routes.draw do
    resources :services do
        
        resources :api_specs do
            member do
                get 'show_swagger', to: 'api_specs#show_swagger'
            end
        end
    end

    get 'overview_dashboard', to: 'dashboards#overview'
    get 'schemas', to: 'schemas#index'
    get 'purposes', to: 'dashboards#purposes'
    get 'network', to: 'dashboards#network'
    get 'utilizer', to: 'utilizers#index'
    get 'schemas/:name/raw_data', to: 'schemas#get_raw_schema_by_name', as: 'schema_spec'
    get 'purposes/:name/raw_data', to: 'schemas#get_purpose_ref_by_names', as: 'purpose_spec'

    root 'services#index'

    scope "/api" do
        scope "v1" do
            scope "/services" do
                post 'update_service' => 'gitlab_repos#update'
                get 'hello' => 'gitlab_repos#hello'
            end
        end

    end
end
