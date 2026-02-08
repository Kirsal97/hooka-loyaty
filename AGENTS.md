# Hooka Loyalty — Agent Reference

## Project Overview

A loyalty program web application for a hookah lounge. Employees register customers, track purchases, and manage reward claims. Customers accumulate points; every N purchases earns a free reward (configurable via settings).

## Key Features

- Client registration and search by phone number
- Purchase tracking with undo (within 5 minutes)
- Reward threshold system (configurable)
- Employee authentication (session-based)
- Multi-language support (English, Russian)
- Real-time search via Turbo Frames
- Admin panel (all purchases view, search/filter)
- Role-based authorization (admin flag on employees)
- PWA-ready, mobile-responsive

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Ruby 4.0.1 |
| Framework | Rails 8.1 |
| Database | SQLite3 via Active Record |
| Frontend | Hotwire (Turbo + Stimulus), ERB templates |
| JS Modules | Importmap (no build step) |
| Asset Pipeline | Propshaft |
| Background Jobs | Solid Queue |
| WebSockets | Solid Cable |
| Caching | Solid Cache |
| Web Server | Puma + Thruster |
| Auth | Bcrypt (password hashing), session-based |
| i18n | rails-i18n, locales: `en`, `ru` |

## Database Schema

- **clients** — name, phone, paid_purchases_count, reward_purchases_count
- **employees** — email, password_digest, admin
- **purchases** — client_id, employee_id, is_reward, note, created_at
- **sessions** — employee session tracking
- **settings** — reward_threshold and other config

## Project Structure

```
app/
  controllers/   # clients, purchases, sessions, settings, passwords, admin/
    concerns/    # authorization
  models/        # Client, Employee, Purchase, Session, Setting
  views/         # ERB templates
  javascript/    # Stimulus controllers
config/
  locales/       # en.yml, ru.yml
  routes.rb
db/
  schema.rb
  migrate/
```

## Common Commands

```bash
bin/rails server        # start dev server
bin/rails db:migrate    # run migrations
bin/rails test          # run tests
bin/rubocop             # lint
bin/brakeman            # security audit
bin/rails admin:grant[email@example.com]   # grant admin privileges
bin/rails admin:revoke[email@example.com]  # revoke admin privileges
```
