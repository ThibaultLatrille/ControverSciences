web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker:  bundle exec rake jobs:work
clock: bundle exec clockwork lib/clock.rb