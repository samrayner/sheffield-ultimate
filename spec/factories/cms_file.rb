FactoryGirl.define do
  factory :cms_file, class: Comfy::Cms::File do
    site_id 1
    label "Image label"
    description "Image description"
    sequence(:file_file_name) { |n| "image-#{n}.jpg" }
    file_content_type "image/jpeg"
    file_file_size 1723956
  end
end
