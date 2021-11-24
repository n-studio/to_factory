describe ToFactory do
  let!(:user) { create_user! }

  def users_file
    File.read("./tmp/factories/to_factory/users.rb")
  rescue
    nil
  end

  let(:expected_users_file) { File.read "./spec/example_factories/users_with_header.rb" }

  context "single call" do
    before do
      ToFactory()
    end
    it "renders a single factory correctly" do
      expect(users_file).to match_sexp expected_users_file
    end
  end

  context "two calls" do
    before do
      ToFactory()
      ToFactory(user_2: ToFactory::User.first)
    end

    it "renders two factories correctly" do
      expect(users_file).to eq <<-FACTORY.strip_heredoc
        FactoryBot.define do
          factory(:"to_factory/user") do
            birthday { "2014-07-08T15:30 UTC" }
            email { "test@example.com" }
            name { "Jeff" }
            some_attributes { { :a => 1 } }
            some_id { 8 }
          end

          factory(:user_2, :parent => :"to_factory/user") do
            birthday { "2014-07-08T15:30 UTC" }
            email { "test@example.com" }
            name { "Jeff" }
            some_attributes { { :a => 1 } }
            some_id { 8 }
          end
        end
      FACTORY
    end
  end

  context "multiple calls" do
    before do
      ToFactory()
      ToFactory(user_2: ToFactory::User.first)
      ToFactory(user_3: ToFactory::User.first)
      ToFactory(user_4: ToFactory::User.first)
    end

    it "renders multiple factories correctly" do
      expect(users_file).to match_sexp <<-FACTORY
       FactoryBot.define do
         factory(:"to_factory/user") do
           birthday { "2014-07-08T15:30 UTC" }
           email { "test@example.com" }
           name { "Jeff" }
           some_attributes { { :a => 1 } }
           some_id { 8 }
         end

         factory(:user_2, :parent => :"to_factory/user") do
           birthday { "2014-07-08T15:30 UTC" }
           email { "test@example.com" }
           name { "Jeff" }
           some_attributes { { :a => 1 } }
           some_id { 8 }
         end

         factory(:user_3, :parent => :"to_factory/user") do
           birthday { "2014-07-08T15:30 UTC" }
           email { "test@example.com" }
           name { "Jeff" }
           some_attributes { { :a => 1 } }
           some_id { 8 }
         end

         factory(:user_4, :parent => :"to_factory/user") do
           birthday { "2014-07-08T15:30 UTC" }
           email { "test@example.com" }
           name { "Jeff" }
           some_attributes { { :a => 1 } }
           some_id { 8 }
         end
       end
      FACTORY
    end
  end
end
