require File.expand_path('../../../spec_helper', __FILE__)

# Note that there's no way to get the current process title defined as a spec
# somewhere. Process.setproctitle explicitly does not change `$0` so the only
# way to get the process title is to shell out.
describe 'Process.setproctitle' do
  platform_is :linux, :darwin do
    ruby_version_is '2.1' do
      before :each do
        @old_title = $0
      end

      after :each do
        Process.setproctitle(@old_title)
      end

      it 'should set the process title' do
        title = 'rubinius-proctitle-test'

        Process.setproctitle(title).should == title
        `ps -f`.include?(title).should     == true
      end
    end
  end
end
