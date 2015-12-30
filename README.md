# [remets](http://remets.herokuapp.com)

[![Circle CI](https://circleci.com/gh/maximebedard/remets.svg?style=svg)](https://circleci.com/gh/maximebedard/remets) [![Code Climate](https://codeclimate.com/github/maximebedard/remets/badges/gpa.svg)](https://codeclimate.com/github/maximebedard/remets) [![Test Coverage](https://codeclimate.com/github/maximebedard/remets/badges/coverage.svg)](https://codeclimate.com/github/maximebedard/remets/coverage)

Handing over documents, made simple.

## Getting started

```sh
brew install postgres redis
bundle exec rake db:create db:migrate
bundle exec rails server # go to localhost:3000

# To load secrets
source ./some-folder-not-in-the-repo/secrets.sh

# Running the test suite and static code analysis
bundle exec rake
```

## Contributing

- Fork it ( https://github.com/maximebedard/remets/fork )
- Create your feature branch (git checkout -b my-new-feature)
- Commit your changes (git commit -am 'Add some feature')
- Push to the branch (git push origin my-new-feature)
- Create a new Pull Request
