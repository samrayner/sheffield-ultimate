module CmsHelper
  def flattened_pages
    return [@cms_site.pages.root] + @cms_site.pages.root.children.published
  end

  def uploaded_file(filename)
    return @cms_site.files.detect{|f| f.file_file_name == filename}
  end

  def image(filename)
    file = uploaded_file(filename)

    unless file
      return '<img src="" alt="Missing image" />'.html_safe
    end

    "<img src=\"#{file.file.url}\" alt=\"#{file.label}\" title=\"#{file.description}\" />".html_safe
  end

  def linked_image(filename)
    file = uploaded_file(filename)
    file_url = file.file.url if file else nil
    "<a href=\"#{file_url}\">#{image(filename)}</a>".html_safe
  end
end
