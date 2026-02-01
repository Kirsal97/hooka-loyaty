# Hooka Loyalty

Loyalty program application built with Ruby on Rails.

## Requirements

- Ruby 4.0.1
- Node.js 24.13.0
- SQLite 3.8+

## Setup

```bash
# Install Ruby dependencies (stored in vendor/bundle)
bundle install

# Install JavaScript dependencies
bin/importmap

# Create and set up the database
bin/rails db:setup

# Install Turbo, Stimulus, and Importmap (first time only)
bin/rails importmap:install
bin/rails turbo:install
bin/rails stimulus:install
```

## Running the app

```bash
bin/rails server
```

The app will be available at http://localhost:3000.

## Running tests

```bash
bin/rails test
```

## Stack

- **Framework:** Rails 8.1
- **Asset Pipeline:** Propshaft
- **JavaScript:** Hotwire (Turbo + Stimulus) via Importmap
- **Database:** SQLite3
- **Background Jobs:** Solid Queue
- **Caching:** Solid Cache
- **WebSockets:** Solid Cable
- **Web Server:** Puma + Thruster
