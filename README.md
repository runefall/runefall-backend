# README

## Development setup

This guide assumes you have installed [Rails 7.1.3](https://guides.rubyonrails.org/v7.1/getting_started.html) and [PostgreSQL >= 14](https://www.postgresql.org/download/)

First, clone the repository to your computer

```sh
git clone git@github.com:runefall/runefall-backend.git
```

Next, install all of the Gems

```sh
bundle install
```

Create, migrate, and seed the databases

```sh
rails db:{create,migrate,seed}
```

Finally, start the development server

```sh
rails s
```

The API will be served on `localhost:3000`.

Run the test suite to diagnose issues

```sh
bundle exec rspec
```