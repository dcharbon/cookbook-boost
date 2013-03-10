require "tmpdir"

filename_version = node.boost.version.gsub(".","_")
filename = "boost_#{filename_version}"
td = Dir.tmpdir
local_tarball = File.join(td, "#{filename}.tar.gz")
tarball_dir = File.join(td, "#{filename}")

remote_file(local_tarball) do
  source "http://sourceforge.net/projects/boost/files/boost/#{node.boost.version}/#{filename}.tar.gz"
  not_if {File.exists?("/usr/local/include/boost/thread.hpp")}
end

bash "extract, make, and install #{local_tarball}" do
  user "root"
  cwd "/tmp"
  code <<-EOS
    tar xzf #{local_tarball}
    cd #{tarball_dir}
    ./bootstrap.sh
    ./b2 install
    cd ..
    rm -rf #{tarball_dir}
    rm #{local_tarball}
  EOS
  
  creates "/usr/local/include/boost/thread.hpp"
end
