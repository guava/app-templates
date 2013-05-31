remove_file "README.rdoc"
create_file "README.md", "TODO"

gem "rspec-rails", group: [:test, :development]
gem "shoulda-matchers", group: [:test]
gem "sorcery"
gem 'therubyracer'
gem "less-rails"

run "bundle install"

generate "rspec:install"
generate "sorcery:install"

css_base = ask('Will it use Zurb Foundation or Twitter Bootstrap? (foundation/bootstrap)')

if css_base[0] == 'b'
  gem 'twitter-bootstrap-rails'
  run "bundle install"

  generate "bootstrap:install less"
else
  gem 'zurb-foundation'
  run "bundle install"

  generate 'foundation:install'
  generate 'foundation:layout'
end

remove_file "public/index.html"

git :init
append_file ".gitignore", "config/database.yml"
run "cp config/database.yml config/example_database.yml"
git add: ".", commit: "-m 'initial commit'"


#### ADDING pt-br TRANSLATION ####

get "https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/pt-BR.yml", "config/locales/pt-BR.yml"
git add: ".", commit: "-m 'Adding translation files'"

#### REMOVING ./test FOLDER ####

remove_dir 'test/'

git commit: '-am "Removing test files"'

#### ADDING SORCERY FILES ####

route "resources :sessions, only: [:new, :create, :destroy]"
route "root to: 'sessions#new'"

file 'app/controllers/sessions_controller.rb', <<-CONTROLLER
class SessionsController < ApplicationController

  def create
    if login(params[:email], params[:password], params[:remember_me])
      redirect_to root_path
    else
      render 'index'
    end
  end

  def destroy
    logout

    redirect_to root_path
  end
end

CONTROLLER

file 'app/views/sessions/new.html.erb', <<-VIEW

  <h1>IMPLEMENT LOGIN</h1>

VIEW

git add: ".", commit: "-m 'Sessions controller.'"
