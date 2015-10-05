# spec/Dockerfile_spec.rb

require "serverspec"
require "docker"

# Workaround needed for circleCI
if ENV['CIRCLECI']
  class Docker::Container
    def remove(options={}); end
    alias_method :delete, :remove
  end
end

describe "Dockerfile" do
  before(:all) do
    image = Docker::Image.build_from_dir('.')

    set :os, :family => 'redhat'
    set :backend, :docker
    set :docker_image, image.id
  end

  it "installs the right version of Centos" do
    expect(os_version).to include("CentOS release 6.7")
  end

  it "installs required packages" do
    expect(package("Percona-Server-server-56")).to be_installed
  end

  describe "percona-release-x86_64 repo should be enabled" do
    describe yumrepo('percona-release-x86_64') do
      it { should be_enabled }
    end
  end

  describe "installs mysql user" do
    describe user('root') do
      it { should exist }
    end
  end

  describe "sets the timezone to EDT" do
    describe file('/etc/localtime') do
      it { should be_linked_to '/usr/share/zoneinfo/EST5EDT' }
    end
  end  
  
  
  describe 'Misc Settings' do
    describe command('mysql -V') do
      its(:stdout) { should include "Distrib 5.6" }
    end
  end
  
  def os_version
    command("/bin/cat /etc/redhat-release").stdout
  end
end
