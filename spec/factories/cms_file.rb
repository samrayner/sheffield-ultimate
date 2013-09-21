FactoryGirl.define do
  factory :cms_file, class: Cms::File do
    site_id 1
    block_id nil
    label "Image label"
    file_file_name "image-1.jpg"
    file_content_type "image/jpeg"
    file_file_size 1723956
    description "Image description"
    position 0
  end
end
