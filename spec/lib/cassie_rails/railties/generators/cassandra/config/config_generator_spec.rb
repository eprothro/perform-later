require "generator_spec"
require "./lib/cassie_rails/railties/generators/cassandra/config/config_generator"

RSpec.describe Cassandra::ConfigGenerator, type: :generator do
  destination File.expand_path("../../tmp", __FILE__)
  arguments []

  before(:all) do
    prepare_destination
  end

  it "saves config with Cassie::Configuration::Generator" do
      generator = double(save: true)
      allow(Cassie::Configuration::Generator).to receive(:new){generator}
      expect(generator).to receive(:save)

      run_generator
  end
  context "when rails application is defined" do
    before(:each) do
      module Rails; def self.application; end; end
      allow(Rails).to receive(:application){double(class: double(parent_name: "CassieRails"))}
    end
    it "passes app name to Cassie::Configuration::Generator" do
      expect(Cassie::Configuration::Generator)
        .to receive(:new)
        .with(hash_including({app_name: 'cassie_rails'})){double(save: true)}

      run_generator
    end
  end
end