module CmsHelper
  def flattened_pages
    return [@cms_site.pages.root] + @cms_site.pages.root.children.published
  end

  def uploaded_file(filename)
    return @cms_site.files.detect{ |f| f.file_file_name == filename }
  end

  def image(filename)
    tag = '<img src="" alt="Missing image" />'
    file = uploaded_file(filename)

    if file
      tag = "<img src=\"#{file.file.url}\" alt=\"#{file.label}\" title=\"#{file.description}\" />"
    end

    tag.html_safe
  end

  def linked_image(filename)
    file = uploaded_file(filename)
    file_url = file.file.url rescue nil
    "<a href=\"#{file_url}\">#{image(filename)}</a>".html_safe
  end
end
