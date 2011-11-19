require 'spec_helper'

describe Build::Job::Test::Php do
  let(:shell)  { stub('shell') }
  let(:config) { Build::Job::Test::Php::Config.new(:composer_args => '--dev') }
  let(:job)    { Build::Job::Test::Php.new(shell, nil , config) }

  describe 'config' do
    it 'defaults :php to "5.3.8"' do
      config.php.should == '5.3.8'
    end
  end

  describe 'setup' do
    it 'switches to the given php version' do
      shell.expects(:execute).with("phpenv global 5.3.8").returns(true)
      job.setup
    end
  end

  describe 'install' do
    it 'returns "composer install --dev" if a composer file exists' do
      job.expects(:composer?).returns(true)
      job.install.should == 'composer install --dev'
    end

    it 'returns nil if the composer file does not exist' do
      job.expects(:composer?).returns(false)
      job.install.should be_nil
    end
  end

  describe 'script' do
    it 'returns "phpunit"' do
      job.send(:script).should == 'phpunit'
    end
  end
end

