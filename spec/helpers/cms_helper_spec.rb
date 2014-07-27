require 'spec_helper'

describe CmsHelper do
  before do
    @cms_site = FactoryGirl.create(:cms_site)
  end

  after do
    Comfy::Cms::File.delete_all
  end

  describe "#flattened_pages" do
    let(:root)  { double(:root_page) }
    let(:child) { double(:child_page) }

    before do
      root.stub_chain(:children, :published).and_return([child, child])
      @cms_site.stub_chain(:pages, :root).and_return(root)
      controller.stub(load_cms_site: @cms_site)
    end

    it "returns an flattened array of root page + children" do
      expect(helper.flattened_pages).to eq([root, child, child])
    end
  end

  describe "#uploaded_file" do
    let!(:image) { FactoryGirl.create(:cms_file, file_file_name: "image-2.png", site_id: @cms_site.id) }

    it "returns the correct file by filename" do
      expect(helper.uploaded_file("image-2.png")).to eq(image)
    end

    it "returns nil for file not found" do
      expect(helper.uploaded_file("nope")).to be_nil
    end
  end

  describe "#uploaded_images" do
    let!(:file1) { FactoryGirl.create(:cms_file, file_content_type: "text/html", site_id: @cms_site.id) }
    let!(:image1) { FactoryGirl.create(:cms_file, file_content_type: "image/jpeg", site_id: @cms_site.id) }
    let!(:image2) { FactoryGirl.create(:cms_file, file_content_type: "image/png", site_id: @cms_site.id) }
    let!(:file2) { FactoryGirl.create(:cms_file, file_content_type: "text/css", site_id: @cms_site.id) }

    before do
      image1.update_attribute(:position, 2)
      image2.update_attribute(:position, 1)
    end

    it "returns only image files ordered by position" do
      expect(helper.uploaded_images).to eq([image2, image1])
    end
  end

  describe "#image" do
    let!(:file) { FactoryGirl.create(:cms_file, file_file_name: "image-1.jpg") }

    before do
      helper.stub(uploaded_file: nil)
      allow(helper).to receive(:uploaded_file).with("image-1.jpg").and_return(file)
    end

    it "returns an image tag for the file" do
      expect(helper.image(file)).to eq('<img src="'+file.file.url+'" alt="Image label" title="Image description" />')
    end

    it "returns an image tag for the filename" do
      expect(helper.image("image-1.jpg")).to eq('<img src="'+file.file.url+'" alt="Image label" title="Image description" />')
    end

    it "returns a broken image tag for a missing file" do
      expect(helper.image("nope")).to eq('<img src="" alt="Missing image" />')
    end
  end

  describe "#linked_image" do
    let!(:file) { FactoryGirl.create(:cms_file, file_file_name: "image-1.jpg") }

    before do
      helper.stub(uploaded_file: nil)
      allow(helper).to receive(:uploaded_file).with("image-1.jpg").and_return(file)
    end

    it "returns a linked image tag for the file" do
      expect(helper.linked_image("image-1.jpg", "foo")).to eq('<a href="'+file.file.url+'" rel="foo"><img src="'+file.file.url+'" alt="Image label" title="Image description" /></a>')
    end

    it "returns a broken linked image tag for a missing file" do
      expect(helper.linked_image("nope", "bar")).to eq('<a href="" rel="bar"><img src="" alt="Missing image" /></a>')
    end
  end

  describe "#gallery" do
    let(:images) { double(:images) }

    before do
      helper.stub(uploaded_images: images)
    end

    it "filters images by category" do
      expect(images).to receive(:for_category).with("foo").and_return([])
      helper.gallery("foo")
    end

    it "wraps multiple linked images" do
      images.stub(for_category: [:image, :image])
      expect(helper).to receive(:linked_image).twice.with(:image, "foo").and_return("X")
      expect(helper.gallery("foo")).to eq('<div class="gallery gallery-foo">XX</div>')
    end

    it "defaults category class to all" do
      expect(images).to receive(:for_category).with(nil).and_return([])
      expect(helper.gallery).to eq('<div class="gallery gallery-all"></div>')
    end
  end
end
