require 'spec_helper'
describe 'winbind' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(clientcert: 'build')
      end
      let(:params) do
        {
          'domainadminuser' => 'admin',
          'domainadminpw' => 'password',
          'domain' => 'EXAMPLE',
          'realm' => 'example.com',
        }
      end

      context 'with defaults for all parameters' do
        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('smb.conf').with(
            'mode' => '0644',
            'owner' => 'root',
            'group' => 'root',
          ).that_requires('Package[samba-client]')
        }
        it {
          is_expected.to contain_service('winbind').with(
            'ensure' => 'running',
            'enable' => true,
            'hasstatus' => true,
            'hasrestart' => true,
          ).that_subscribes_to('File[smb.conf]')
        }
        it {
          is_expected.to contain_file_line('let-winbind-use-custom-smbconf-file').that_notifies('Service[winbind]')
        }
        it {
          is_expected.to contain_package('samba-client').with_ensure('installed')
        }
        it {
          is_expected.to contain_package('samba-winbind-clients').with_ensure('installed')
        }
        it {
          is_expected.to contain_package('samba-winbind').with_ensure('installed')
        }
        it {
          is_expected.to contain_exec('add-to-domain').that_notifies('Service[winbind]')
        }

        it { is_expected.to contain_exec('add-to-domain').that_requires(['File[smb.conf]', 'Package[samba-winbind-clients]']) }
        it { is_expected.to contain_service('winbind').that_requires(['File[smb.conf]', 'Package[samba-winbind]']) }
        it { is_expected.to contain_file('smb.conf').that_notifies(['Exec[add-to-domain]', 'Service[winbind]']) }
      end
    end
  end
end
