# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '4.7'
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.conf*ig.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( chart.js )
Rails.application.config.assets.precompile += %w( not_logged.js )
Rails.application.config.assets.precompile += %w( comics.js )
Rails.application.config.assets.precompile += %w( tagcanvas.js )
Rails.application.config.assets.precompile += %w( voronoi.js )
Rails.application.config.assets.precompile += %w( morphSVG.js )
Rails.application.config.assets.precompile += %w( diff_match_patch.js )
Rails.application.config.assets.precompile += %w( prettyDiff.js )