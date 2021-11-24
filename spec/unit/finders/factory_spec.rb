describe ToFactory::Finders::Factory do
  describe "#call" do
    before do
      FileUtils.mkdir_p "./tmp/factories/to_factory"
      FileUtils.cp "./spec/example_factories/users_admin_with_header.rb",
                   "./tmp/factories/to_factory/users.rb"
    end

    let(:users_file_contents) { File.read "./spec/example_factories/users.rb" }
    let(:admins_file_contents) { File.read "./spec/example_factories/admins.rb" }

    it "reads all the factories" do
      finder = ToFactory::Finders::Factory.new

      result = finder.call

      expect(result[0].definition)
        .to match_sexp users_file_contents

      expect(result[1].definition)
        .to match_sexp admins_file_contents
    end
  end
end
