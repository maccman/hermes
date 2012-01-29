namespace :macgap do
  task :build do
    `macgap --name Hermes ./macgap`
    `zip -r Hermes.zip Hermes.app`
  end
end