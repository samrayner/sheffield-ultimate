namespace :fixtures do
  namespace :local do
    task :export do
      Comfy::Cms::Site.all.each do |site|
        ENV['FROM'] = site.identifier
        ENV['TO']   = site.identifier
        Rake::Task['comfortable_mexican_sofa:fixtures:export'].invoke
      end
    end
  end

  #https://gist.github.com/Onumis/288baf157a0dee905d2b
  namespace :s3 do
    require 'fileutils'

    def cms_export from, to
      # create the fixtures files from DB
      ComfortableMexicanSofa::Fixture::Exporter.new(from, to).export!

      # get the bucket
      bucket = AWS::S3.new.buckets[ENV['AWS_BUCKET_FIXTURES']]
      unless bucket.exists?
        bucket = AWS::S3.new.buckets.create(ENV['AWS_BUCKET_FIXTURES'])
      end

      # delete contents on bucket
      bucket.objects.with_prefix("db/cms_fixtures/#{to}").delete_all

      # GO OVER ALL FILES AND UPLOAD
      Dir.glob("db/cms_fixtures/#{to}/**/*.*") do |path|
        obj = bucket.objects.create path, Pathname.new(path)
        puts "uploaded file #{path}"
      end
    end

    def cms_import from, to
      # get the bucket
      bucket = AWS::S3.new.buckets[ENV['AWS_BUCKET_FIXTURES']]
      unless bucket.exists?
        raise "Bucket #{ENV['AWS_BUCKET_FIXTURES']} not found!"
        exit 1
      end

      # delete contents on folder
      FileUtils.rm_rf("db/cms_fixtures/#{from}/")
      FileUtils.mkdir_p("db/cms_fixtures/#{from}/")

      # download fixture files
      bucket.objects.with_prefix("db/cms_fixtures/#{from}").each do |obj|
        # create dir
        dirname = File.dirname(obj.key)
        unless File.directory?(dirname)
          FileUtils.mkdir_p(dirname)
        end
        # download file
        File.open(obj.key, 'wb') do |file|
          obj.read do |chunk|
            file.write(chunk)
          end
        end
        puts "downloaded file #{obj.key}"
      end

      # import to DB
      ComfortableMexicanSofa::Fixture::Importer.new(from, to, :force).import!
    end

    desc "Export local CMS fixtures to S3 Bucket"
    task :export => :environment do
      Comfy::Cms::Site.all.each do |site|
        cms_export site.identifier, site.identifier
      end
    end

    desc "Import CMS fixtures on S3 Bucket"
    task :import => :environment do
      Comfy::Cms::Site.all.each do |site|
        cms_import site.identifier, site.identifier
      end
    end
  end
end
