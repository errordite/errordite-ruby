# Errordite

A ruby client for https://www.errordite.com

## Adding errordite to your application

There are different gems for general, rack, and rails applications, so add either `errordite`, `errordite-rack` or `errordite-rails` to your `Gemfile` and reinstall the bundle.

For rails applications, errordite will automatically be added to capture and log all errors thrown during a request.  For rack applications, you'll need to explicitly add rack middleware, adding something like this to your `config.ru` file:

    use Errordite::Rack

## Setting the errordite api token

Errordite uses a unique api token to identify users, and you'll need to set this before it can record errors.  This can be done in one of two ways.  The first (and preferred method) is to set the environment variable `ERRORDITE_TOKEN` with your API key.  If this isn't possible you can also directly set `Errordite.config.api_key`.

## Capturing non-request related errors

Using `errordite-rail` or adding the `Errordite::Rack` middleware will capture errors that occur during a request to your application, but it's also useful to capture errors that happen outside a web process.  An example might be errors from a job queue or similar.  This is easy to achieve, using `Errordite.monitor(&block)`.  e.g.:

    Errordite.monitor do
      ErrorProneQueue.process_next_job
    end
