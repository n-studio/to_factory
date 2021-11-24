describe "non active record classes" do
  let!(:project) { create_project! }

  def projects_file
    File.read("./tmp/factories/to_factory/projects.rb")
  rescue
    nil
  end

  def inherited_projects_file
    File.read("./tmp/factories/to_factory/inherited_projects.rb")
  rescue
    nil
  end

  let(:expected_projects_file) { File.read "./spec/example_factories/projects_with_header.rb" }
  let(:expected_inherited_projects_file) { File.read "./spec/example_factories/inherited_projects_with_header.rb" }

  context "given a folder with non active record models in" do
    before do
      ToFactory.models = "./spec/support/non_active_record"
      ToFactory()
    end

    it "creates an ordinary factory correctly" do
      expect(projects_file).to match_sexp expected_projects_file
    end

    context "STI" do
      it "creates a single factory correctly" do
        expect(inherited_projects_file).to match_sexp expected_inherited_projects_file
      end
    end

    it "doesn't create other factories" do
      count = Dir.glob("./tmp/factories/*.rb").length
      expect(count).to eq 0
    end
  end
end
