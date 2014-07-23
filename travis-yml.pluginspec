Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = "travis-yml"
  plugin.display_name = "Travis YAML Plugin"
  plugin.version = '0.1.0'
  plugin.description = 'Run job using .travis.yml'

  plugin.url = 'https://github.com/masaki/jenkins-travis-yml-plugin'
  plugin.developed_by "ikasam_a", "ikasam_a <masaki.nakagawa@gmail.com>"
  plugin.uses_repository :github => "masaki/jenkins-travis-yml-plugin"

  plugin.depends_on 'ruby-runtime', '0.10'
  plugin.depends_on 'git', '1.1.11'
end
