module CmsHelper
  def flattened_pages
    [@cms_site.pages.root] + @cms_site.pages.root.children.published
  end

  def uploaded_file(filename)
    @cms_site.files.find_by_file_file_name(filename)
  end

  def uploaded_images
    @cms_site.files.where("file_content_type LIKE 'image/%'").order(:position)
  end

  def image(file)
    file = uploaded_file(file) if file.kind_of?(String)
    tag = '<img src="" alt="Missing image" />'

    if file
      tag = "<img src=\"#{file.file.url}\" alt=\"#{file.label}\" title=\"#{file.description}\" />"
    end

    tag.html_safe
  end

  def linked_image(file, group=nil)
    file = uploaded_file(file) if file.kind_of?(String)
    file_url = file.file.url rescue nil

    "<a href=\"#{file_url}\" rel=\"#{group}\">#{image(file)}</a>".html_safe
  end

  def gallery(category=nil)
    html = '<div class="gallery gallery-'+(category || "all")+'">'

    uploaded_images.for_category(category).each do |file|
      html += linked_image(file, category)
    end

    (html + '</div>').html_safe
  end
end
