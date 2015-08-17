require 'simplecov'
SimpleCov.start 'rails' do
  add_filter 'vendor' # Don't include vendored stuff
  add_filter '.bundle'
  add_filter 'lib/tasks'
end

require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'

RSpec.configure do |config|
  # Don't require type: :model in spec/models/*.rb etc
  config.infer_spec_type_from_file_location!
end

def import_fixtures(site_identifier)
  FactoryGirl.create(:cms_site, identifier: site_identifier)
  ComfortableMexicanSofa::Fixture::Importer.new("#{site_identifier}-spec", site_identifier, :force).import!
end

def delete_all_cms_data
  [Comfy::Cms::Site, Comfy::Cms::Layout, Comfy::Cms::Page, Comfy::Cms::File].each(&:delete_all)
end
