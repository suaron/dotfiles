let g:rails_projections = {
\    "db/seeds/*.rb": {
\      "command": "seed"
\    },
\    "app/forms/*.rb": {
\      "command": "form",
\      "test": "spec/forms/%s_spec.rb",
\      "template": "class %S\nend"
\    },
\    "app/workers/*.rb": {
\      "command": "worker",
\      "test": "spec/workers/%s_spec.rb",
\      "template": "class %S\n\n  def perform\n  end\nend"
\    },
\    "app/services/*.rb": {
\      "command": "service",
\      "affinity": "model",
\      "test": "spec/services/%s_spec.rb",
\      "related": "app/models/%s.rb",
\      "template": "class %S\n\n  def run\n  end\nend"
\    },
\    "Gemfile": { "command": "gemfile"  },
\    "config/*.rb": { "command": "cfg"  },
\    "spec/support/*.rb": {"command": "support"},
\    "spec/features/*_spec.rb": {
\      "command": "feature",
\      "template": "require 'spec_helper'\n\nfeature '%h' do\n\nend",
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
