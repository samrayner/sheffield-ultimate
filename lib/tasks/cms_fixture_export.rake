namespace :db do
  task :export do
    ENV['FROM'] = 'sheffield-ultimate' #site identifier
    ENV['TO']   = 'sheffield-ultimate' #fixtures dir
    Rake::Task['comfortable_mexican_sofa:fixtures:export'].invoke
  end
end
