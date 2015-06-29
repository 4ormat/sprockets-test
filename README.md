Test app for sprockets precompile bug https://github.com/rails/sprockets/issues/59

so basically you can run "time bundle exec rake precompile"

[3:05 PM] mike: so basically you can run "time bundle exec rake precompile"

[3:05 PM] mike: and you'll notice a time diff when it does a full precompile

[3:05 PM] mike: though it's much more obvious if you add a LOT of assets

[3:05 PM] mike: (I was testing with ~500mb of images)

[3:05 PM] mike: if you change the absolute path of the repo clone, and run precompile again, you should see a full precompile

[3:06 PM] mike: (I was just changing the name of the clone's dir)

[3:06 PM] mike: if you re-run without changing any paths, it'll finish in 1 sec
