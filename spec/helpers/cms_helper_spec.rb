require 'spec_helper'

describe CmsHelper do
  before do
    @cms_site = double(:cms_site)
  end

  after do
    Cms::File.delete_all
  end

  describe :flattened_pages do
    before do
      @root = double(:root_page)
      @child = double(:child_page)
      @root.stub_chain(:children, :published).and_return([@child, @child])

      @cms_site.stub_chain(:pages, :root).and_return(@root)
      controller.stub(load_cms_site: @cms_site)
    end

    it "returns an flattened array of root page + children" do
      flattened_pages.should == [@root, @child, @child]
    end
  end

  describe :uploaded_file do
    before do
      file1 = FactoryGirl.create(:cms_file, file_file_name: "image-1.jpg")
      @file2 = FactoryGirl.create(:cms_file, file_file_name: "image-2.png")
      file3 = FactoryGirl.create(:cms_file, file_file_name: "image-3.bmp")
      @cms_site.stub(files: [file1, @file2, file3])
    end

    it "returns the correct file by filename" do
      uploaded_file("image-2.png").should == @file2
    end

    it "returns nil for file not found" do
      uploaded_file("nope").should be_nil
    end
  end

  describe :image do
    before do
      @image = FactoryGirl.create(:cms_file, file_file_name: "image-1.jpg")
      @url = "/system/cms/files/files/000/000/001/original/image-1.jpg"
      @image.stub_chain(:file, :url).and_return("/system/cms/files/files/000/000/001/original/image-1.jpg")
      @cms_site.stub(files: [@image])
    end

    it "returns an image tag for the file" do
      image("image-1.jpg").should == '<img src="'+@url+'" alt="Image label" title="Image description" />'
    end

    it "returns a broken image tag for a missing file" do
      image("nope").should == '<img src="" alt="Missing image" />'
    end
  end

  describe :linked_image do
    before do
      @image = FactoryGirl.create(:cms_file, file_file_name: "image-1.jpg")
      @url = "/system/cms/files/files/000/000/001/original/image-1.jpg"
      @image.stub_chain(:file, :url).and_return(@url)
      @cms_site.stub(files: [@image])
    end

    it "returns an image tag for the file" do
      linked_image("image-1.jpg").should == '<a href="'+@url+'"><img src="'+@url+'" alt="Image label" title="Image description" /></a>'
    end

    it "returns a broken linked image tag for a missing file" do
      linked_image("nope").should == '<a href=""><img src="" alt="Missing image" /></a>'
    end
  end
end
