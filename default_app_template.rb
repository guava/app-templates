remove_file "README.rdoc"
create_file "README.md", "TODO"

gem "rspec-rails", group: [:test, :development]
gem "shoulda-matchers", group: [:test]
gem "sorcery"
run "bundle install"
generate "rspec:install"
generate "sorcery:install"

generate :controller, "sessions"
route "resource :sessions, only: [:new, :create]"
route "root to: 'sessions#new'"

remove_file "public/index.html"

git :init
append_file ".gitignore", "config/database.yml"
run "cp config/database.yml config/example_database.yml"
git add: ".", commit: "-m 'initial commit'"
