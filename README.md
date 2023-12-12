# Visit a heat pump

A web app to host and attend events to visit a heat pump near you.

## Getting started

These instructions will get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Ruby (see .ruby-version) and PostgreSQL.

### Local setup

1. Clone the repo, i.e. `git clone https://github.com/nestauk/afs_visit_a_heat_pump.git`
2. Navigate to the root directory of the project.
3. `bundle install` to install Ruby dependencies.
4. `bin/dev` to start a local development server.

If you need to import an existing database you can use a utility like `pg_restore`.

Most features should work locally though for some you may need to add the appropriate credentials - see the `.env.template` for an example. You may need to set up accounts for the relevant services or contact a maintainer for the keys.

### Running tests

- `rails test` to run unit tests.
- `rails test:system` to run system/end-to-end tests.

## Deployment

We currently use Heroku to host and deploy this app.

### Heroku Scheduler

Tasks which should be run every day are:

- `rake scheduler:notify`

## Contributing

First of all, **thank you** for your help!

Be sure to check out the projects open [issues](https://github.com/nestauk/afs_visit_a_heat_pump/issues) to see where help is needed - those labeled [good first issue](https://github.com/nestauk/afs_visit_a_heat_pump/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22) can be a good place to start.

### Bugs

If you've spotted a bug please file an [issue](https://github.com/nestauk/afs_visit_a_heat_pump/issues) and apply the `bug` label. Even better, submit a [pull request](https://github.com/nestauk/afs_visit_a_heat_pump/pulls) (details below) with a patch.

### Pull requests

If you want a feature added the best way to get it done is to submit a pull request that implements it...

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Implement your changes
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to GitHub (`git push origin my-new-feature`)
6. Create a [pull request](https://github.com/nestauk/afs_visit_a_heat_pump/compare/main...my-new-feature) into the [main](https://github.com/nestauk/afs_visit_a_heat_pump/tree/main) branch

Alternatively you can submit an [issue](https://github.com/nestauk/afs_visit_a_heat_pump/issues) describing the feature.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/nestauk/afs_visit_a_heat_pump/tags).
