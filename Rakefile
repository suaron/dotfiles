desc "Install default gems"
task :install_global_gems do
  %w{ bundler awesome_print cheat wirble bond gem-browse }.each do |gem_name|
    puts `gem install #{gem_name}`
  end
end

task :default => [
  :install_global_gems
]
