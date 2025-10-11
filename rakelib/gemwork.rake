# frozen_string_literal: true

spec = Gem::Specification.find_by_name("gemwork")

# Load additional tasks defined by Gemwork.
gem_path = Pathname.new(spec.gem_dir)
rake_tasks_path_glob =
  gem_path.join("lib/tasks/{util,test,rubocop,reek,prettier}.rake")
Dir.glob(rake_tasks_path_glob) do |task|
  load(task)
end

# Redefine the default `rake` task.
task :default do
  run_tasks(%i[
    test
    rubocop
    reek
    prettier
  ])
end
