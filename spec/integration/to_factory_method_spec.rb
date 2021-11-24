describe ToFactory do
  let!(:user)    { create_user! }
  let!(:project) { create_project! }

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

  let(:expected_users_file) { File.read "./spec/example_factories/users_with_header.rb" }
  let(:expected_projects_file) { File.read "./spec/example_factories/projects_with_header.rb" }

  describe "ToFactory.definitions" do
    it do
      ToFactory()
      expect(ToFactory.definitions).to match_array ["to_factory/user", "to_factory/project"]
    end
  end

  describe "ToFactory.definition_for" do
    let(:expected_users_file) { File.read "./spec/example_factories/users.rb" }
    it do
      expect(ToFactory.definition_for user).to match_sexp expected_users_file
    end

    it do
      ToFactory(user)
      expect(ToFactory.definition_for :"to_factory/user").to match_sexp expected_users_file
    end

    it "raises a not found error" do
      expect(-> { ToFactory.definition_for :"to_factory/user" }).to raise_error ToFactory::NotFoundError
    end
  end

  describe "Object#ToFactory" do
    context "with multiple levels of parent classes" do
      let(:filename) { "spec/example_factories/#{'users_admin_super_admin'}.rb" }

      it "gets the output order correct" do
        output = "./tmp/factories/to_factory/users.rb"
        `mkdir -p ./tmp/factories/to_factory`
        `cp #{filename} #{output}`

        ToFactory(root: user)

        expected = File.read "spec/example_factories/#{'users_admin_root'}.rb"

        # user, admin, super_admin, root
        expect(File.read(output)).to match_sexp expected
      end
    end

    it "generates all factories" do
      ToFactory()
      # simple check for equivalent ruby
      expect(users_file)   .to match_sexp expected_users_file
      expect(projects_file).to match_sexp expected_projects_file

      # once we are sure output is equivalent ruby, check output is identical
      expect(users_file.chomp)   .to eq expected_users_file.chomp
      expect(projects_file.chomp).to eq expected_projects_file.chomp
    end

    def users_file_includes(content)
      expect(users_file).to include content
    end

    context "excluding classes" do
      before do
        user
        project
      end

      it "ignores specified classes" do
        ToFactory(exclude: ToFactory::User)
        expect(users_file).to be_nil
        expect(projects_file).to be_present
      end

      it "ignores specified classes - sanity check" do
        ToFactory(exclude: ToFactory::Project)
        expect(users_file).to be_present
        expect(projects_file).to be_nil
      end
    end

    context "with no existing file" do
      it "creates the file" do
        expect(users_file).to be_nil
        ToFactory(user)
        expect(users_file).to be_present
      end

      context "with single ActiveRecord::Base instance argument" do
        it "creates the file" do
          expect(users_file).to be_nil
          ToFactory(user)
          expect(users_file).to be_present
        end
      end
    end

    context "with an existing file" do
      before do
        expect(users_file).to be_nil
        ToFactory(user)
        expect(users_file).to be_present
      end

      context "with a name for the factory" do
        it "appends to the file" do
          users_file_includes('factory :"to_factory/user"')
          ToFactory(specific_user: user)
          users_file_includes('factory :specific_user, parent: :"to_factory/user"')
        end
      end

      it "without a name" do
        expect(-> { ToFactory(user) })
          .to raise_error ToFactory::AlreadyExists
      end
    end
  end
end
