require 'rspec'
require 'vagrant-mount/command_mount'

describe VagrantPlugins::Mount::Command::Mount do
  describe 'help' do
    let (:argv) { [] }
    let (:env)  { [] }
    subject { described_class.new(argv, env) }

    context 'with no arguments' do
      it 'shows help' do
        expect { subject.execute }.to raise_error(Vagrant::Errors::CLIInvalidUsage)
      end
    end

  end
end
