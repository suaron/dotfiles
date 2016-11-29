let g:rails_projections = {
\    "test/*.rb": {
\      "command": "test"
\    },
\    "app/policies/*.rb": {
\      "command": "policies",
\      "test": "spec/policies/%s_spec.rb"
\    },
\    "app/forms/*.rb": {
\      "command": "forms",
\      "test": "spec/forms/%s_spec.rb"
\    },
\    "db/seeds/*.rb": {
\      "command": "seed"
\    },
\    "app/serializers/*.rb": {
\      "command": "serializer",
\      "test": "spec/serializers/%s.rb",
\      "template": "class %S < ActiveModel::Serializer\n\nend"
\    },
\    "app/messengers/*.rb": {
\      "command": "messengers",
\      "test": "spec/messengers/%s.rb"
\    },
\    "app/workers/*.rb": {
\      "command": "worker",
\      "test": "spec/workers/%s_spec.rb",
\      "template": "class %S\n\n  def perform\n  end\nend"
\    },
\    "app/queries/*.rb": {
\      "command": "queries",
\      "test": "spec/queries/%s_spec.rb",
\      "template": "class %S\nend"
\    },
\    "app/services/*.rb": {
\      "command": "service",
\      "test": "spec/services/%s_spec.rb",
\      "alternate": ["spec/services/%s_spec.rb"],
\      "template": "class %S\n  def initialize\n  end\nend"
\    },
\    "app/decorators/*.rb": {
\      "command": "decorator",
\      "test": "spec/decorators/%s_spec.rb",
\      "template": "class %S < LittleDecorator\nend"
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
\    },
\    "app/validators/*.rb": {
\      "command": "validator",
\      "template": "class %S < ActiveModel::EachValidator\n  def validate_each(record, attribute, value)\n  end\nend"
\    }
\ }
