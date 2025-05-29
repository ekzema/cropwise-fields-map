## Developer Setup

### Run with docker compose:
```bash
# Create a build
docker compose build

# Create a database
docker compose run --rm web bundle exec rails db:create

# Run migrations
docker compose run --rm web bundle exec rails db:migrate

# Run application
docker compose up
```

### Simple application run:
```bash
# Run gems
bundle install

# Create a database
rails db:create

# Run migrations
rails db:miration

# Run application
bin/dev
```
