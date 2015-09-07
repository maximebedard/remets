# [remets](http://remets.herokuapp.com)

Handing over documents, made simple.

## Getting started

```sh
brew install pg
bundle exec rake db:create db:migrate
bundle exec rails server # go to localhost:3000

# To load secrets
source ./some-folder-not-in-the-repo/secrets.sh
```

## Styleguide

[Ruby style guide](https://github.com/styleguide/ruby)

## Deployment

The deployment process is made using heroku pipeline. WIP.

## TODOs

- [ ] Store user sessions in cookies (remember me)
- [ ] Create a distinction between text file and source file
- [ ] Extract into jobs
  - [ ] Text analysis job
    - [ ] Shingling
    - [ ] Winnowing
  - [ ] Source analysis job
    - [ ] Research algorithms available
- [ ] Performance comparaisons

