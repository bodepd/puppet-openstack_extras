require 'spec_helper'

describe 'openstack_extras::test_file' do
  it do
    should contain_file('/tmp/test_nova.sh').with_mode('0751')
    should_not contain_file('/tmp/test_nova.sh').with_content(/add-floating-ip/)
    should contain_file('/tmp/test_nova.sh').with_content(/floatingip-create/)
  end
  describe 'when setting pre_ssh_cmd' do
    let :params do
      {
        'pre_ssh_cmd' => 'echo "foo"'
      }
    end
    it { should contain_file('/tmp/test_nova.sh').with_content(
      /echo "foo"/
    ) }
  end
end
