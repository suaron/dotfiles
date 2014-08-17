let g:rails_projections = {
\    "test/*.rb": {
\      "command": "test"
\    },
\    "db/seeds/*.rb": {
\      "command": "seed"
\    },
\    "app/serializers/*.rb": {
\      "command": "serializer",
\      "test": "spec/serializers/%s.rb",
\      "template": "class %S < ActiveModel::Serializer\n\nend"
\    },
\    "app/workers/*.rb": {
\      "command": "worker",
\      "test": "spec/workers/%s_spec.rb",
\      "template": "class %S\n\n  def perform\n  end\nend"
\    },
\    "app/queries/*.rb": {
\      "command": "queries",
\      "test": "spec/queries/%s_spec.rb",
\      "template": "class %SQuery\n\nend"
\    },
\    "app/services/*.rb": {
\      "command": "service",
\      "test": "spec/services/%s_spec.rb",
\      "template": "class %S\n\n  def initialize\n  end\nend"
\    },
\    "app/uploaders/*.rb": {
\      "command": "uploaders",
\      "test": "spec/uploaders/%s_spec.rb"
\    },
\    "Gemfile": { "command": "gemfile"  },
\    "config/*": { "command": "cfg"  },
\    "config/routes.rb": { "command": "routes"  },
\    "spec/support/*.rb": {"command": "support"},
\    "spec/features/*_spec.rb": {
\      "command": "feature",
\      "template": "require 'spec_helper'\n\nfeature '%h' do\n\nend",
\    },
\    "spec/factories/*.rb": {
\      "command": "factories",
\    }
\ }
 
let g:rails_gem_projections = {
\   "carrierwave": {
\     "app/uploaders/*_uploader.rb": {
\       "command": "uploader",
\       "template":
\       "class %SUploader < CarrierWave::Uploader::Base\nend"
\     }
\   },
\   "worker": {
\     "app/workers/*_job.rb": {
\       "command": "worker",
\       "template": "class %SJob\n\n  \n@queue = :main\ndef self.perform\n  end\nend"
\     }
\   },
\   "draper": {
\     "app/decorators/*_decorator.rb": {
\       "command": "decorator",
\       "affinity": "model",
\       "test": "spec/decorators/%s_spec.rb",
\       "related": "app/models/%s.rb",
\       "template": "class %SDecorator < Draper::Decorator\nend"
\     }
\   }
\ }
