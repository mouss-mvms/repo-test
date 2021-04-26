# MVMS-API-CATALOG

### Integrate mvms-core GEM ###
```bash
bundle config https://gem.fury.io/mvms/ 1NRAu1-s5LftEnpweDkWewfASsrNMbVmaQ
```

```bash 
bundle install
```

### During the development ###

1) run ```rails g mvms:core:copy_migrations``` to get migrations from gem
2) run ```rails db:migrate RAILS_ENV=<your_env>```
3) run ```rails data:migrate RAILS_ENV=<your_env>``` (optional)

#### If you need to modify the mvms-core gem :
1) In your Gemfile, change

From :
```
# MVMS Core
source 'https://gem.fury.io/mvms/' do
 gem 'mvms-core', '2.4.14'
end
```

To :
```
# MVMS Core
gem 'mvms-core', path: 'path/toSource'
```

2) Run ```bundle install```

### During pull request ###

#### If you modified the mvms-core gem,
1) PR and MERGE your work in gem (MUST do that before continue)
2) In your Gemfile, change

From :
```
# MVMS Core
gem 'mvms-core', path: 'path/toSource'
```

To :
```
# MVMS Core
source 'https://gem.fury.io/mvms/' do
 gem 'mvms-core', '2.4.14'
end
```
3) Change version of gem
4) Run ```bundle install```
5) Check the Gemfile.lock, only the part of mvms-core gem should be changed with your version
6) Test the app
7) Run Unit Tests
8) Commit you files (with gemfile.lock ;))
9) Send your PR
