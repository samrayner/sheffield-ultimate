namespace :db do
  namespace :test do
    task :prepare => :environment do
      site_identifier = "sheffield-ultimate"
      Cms::Site.create(label: "Sheffield Ultimate", identifier: site_identifier, hostname: "localhost", path: "", locale: "en", is_mirrored: false)
      ENV['FROM'] = 'sheffield-ultimate' #fixtures dir
      ENV['TO']   = site_identifier
      Rake::Task['comfortable_mexican_sofa:fixtures:import'].invoke
    end
  end
end
