require 'rspec'
require 'helpers/isolated_environment'
require 'vagrant-mount/command_mount'

describe VagrantPlugins::Mount::Command::Mount do
  describe 'help' do
    let (:argv) { [] }
    let (:env)  do
      IsolatedEnvironment.new.create_environment
    end

    subject { described_class.new(argv, env) }

    context 'with no arguments' do
      it 'shows help' do
        expect { subject.execute }.to raise_error(Vagrant::Errors::CLIInvalidUsage)
      end
    end

    context 'with an ISO' do
      let(:argv) { [ 'dummy.iso' ] }

      it 'mounts it' do
        expect(subject.execute).to eq(0)
      end
    end
  end
end
