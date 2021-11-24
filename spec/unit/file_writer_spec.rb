describe ToFactory::FileWriter do
  let(:fw) { ToFactory::FileWriter.new }

  describe "#write" do
    def users_file
      File.read("tmp/factories/to_factory/users.rb")
    end

    def projects_file
      File.read("tmp/factories/to_factory/projects.rb")
    end

    it "adds factories for all models" do
      user_representation = double :name => :user, "definition" => "factory a"
      project_representation = double name: "project", definition: "factory b"
      fw.write("to_factory/users" => [user_representation],
               "to_factory/projects" => [project_representation])

      expect(users_file).to match /FactoryBot.define do/
      expect(users_file).to include "factory a"
      expect(projects_file).to include "factory b"
    end
  end
end
