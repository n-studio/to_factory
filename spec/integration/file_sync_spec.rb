describe "FileSync" do
  let(:user) { create_user! }
  let(:admin) { create_admin! }
  let(:project) { create_project! }
  let(:expected_users_file)             { File.read("./spec/example_factories/users.rb") }
  let(:expected_users_with_header_file) { File.read("./spec/example_factories/users_with_header.rb") }
  let(:expected_admin_file)            { File.read("./spec/example_factories/admins.rb") }
  let(:users_with_header)               { File.read("./spec/example_factories/users_with_header.rb") }
  let(:users_admin_with_header)         { File.read("./spec/example_factories/users_admin_with_header.rb") }

  def users_file
    File.read("./tmp/factories/to_factory/users.rb")
  rescue
    nil
  end

  def projects_file
    File.read("./tmp/factories/to_factory/projects.rb")
  rescue
    nil
  end

  context "with no arguments" do
    before do
      user
      admin
    end

    it "finds the first existing instance" do
      sync = ToFactory::FileSync.new
      sync.perform

      expect(users_file).to match_sexp expected_users_with_header_file
    end
  end

  context "with an instance" do
    it "writes that instance" do
      sync = ToFactory::FileSync.new(user)
      sync.perform

      expect(users_file).to match_sexp users_with_header
      expect(projects_file).to eq nil
    end
  end

  context "with a pre-existing file" do
    let(:sync) { ToFactory::FileSync.new(user) }
    before do
      sync.perform
      expect(users_file).to match_sexp users_with_header
    end

    it "raises an error" do
      expect(-> { sync.perform }).to raise_error ToFactory::AlreadyExists
    end

    context "with a named factory" do
      it do
        sync = ToFactory::FileSync.new(admin: admin)
        sync.perform

        parser = ToFactory::Parsing::File.new(users_file)
        result = parser.parse
        admin = result.find { |r| r.name == "admin" }
        user = result.find { |r| r.name == "to_factory/user" }

        expect(admin.definition).to match_sexp expected_admin_file
        expect(user.definition).to match_sexp expected_users_file

        expect(lambda do
          sync.perform
        end).to raise_error ToFactory::AlreadyExists
      end
    end
  end
end
