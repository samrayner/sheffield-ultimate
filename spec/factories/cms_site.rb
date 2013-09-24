FactoryGirl.define do
  factory :cms_site, class: Cms::Site do
    label "My Website"
    identifier "my-website"
    hostname "localhost"
    path ""
    locale "en"
    is_mirrored false
  end
end
