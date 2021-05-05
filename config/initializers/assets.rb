# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# include swagger subdir
Rails.application.config.assets.paths << Rails.root + 'app/assets/javascripts/swagger'
Rails.application.config.assets.paths << Rails.root + 'app/assets/stylesheets/swagger'
# and precomile swagger js
Rails.application.config.assets.precompile += %w( swagger-ui-bundle.js )
Rails.application.config.assets.precompile += %w( swagger-ui-standalone-preset.js )
Rails.application.config.assets.precompile += %w( swagger-ui.css )


# Rails.application.config.assets.precompile += %w( cytoscape/cytoscape.js )
# Rails.application.config.assets.precompile += %w( cytoscape/cytoscape-popper.js )
# Rails.application.config.assets.precompile += %w( cytoscape/popper.js )

Rails.application.config.assets.precompile += %w( jquery-multi-select.js )
Rails.application.config.assets.precompile += %w( popper.js )
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
