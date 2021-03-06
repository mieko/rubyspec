require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "IO#ioctl" do
  it "raises IOError on closed stream" do
    lambda { IOSpecs.closed_io.ioctl(5, 5) }.should raise_error(IOError)
  end

  platform_is :os => :linux do
    it "resizes an empty String to match the output size" do
      File.open(__FILE__, 'r') do |f|
        buffer = ''
        # FIONREAD in /usr/include/asm-generic/ioctls.h
        f.ioctl 0x541B, buffer
        buffer.unpack('I').first.should be_kind_of(Integer)
      end
    end

    it "raises an Errno error when ioctl fails" do
      File.open(__FILE__, 'r') do |f|
        lambda {
          # TIOCGWINSZ in /usr/include/asm-generic/ioctls.h
          f.ioctl 0x5413, nil
        }.should raise_error(Errno::ENOTTY)
      end
    end
  end
end
