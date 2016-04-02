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

## Roadmap

- [ ] Fix the differ
  - [ ] Remove very small diffs as they are irrelevant
  - [ ] Contextualize every diffs
  - [ ] Provide a link on the diff to see in the whole context
- [ ] Provide an inline viewer for a document
- [ ] Add teams
- [ ] Add notifications
- [ ] Add Google Calendar integration
- [ ] Add snapshot from 3rd party
- [ ] Add acceptance tests
- [ ] Refactor documents to provide and intermediary model
- [ ] Add Webhooks
- [ ] Add API docs (https://github.com/tripit/slate is good enough)
- [ ] Add permissions (per submission, per organization)
- [ ] Fix the html5 drag and drop
- [ ] Add graphql api (cauz this is cool)

## Contributing

- Fork it ( https://github.com/maximebedard/remets/fork )
- Create your feature branch (git checkout -b my-new-feature)
- Commit your changes (git commit -am 'Add some feature')
- Push to the branch (git push origin my-new-feature)
- Create a new Pull Request
