# Recipe to install a unsupported/experimental of ffmpeg (0.6)
# In order to install this we need the following in /etc/portage/package.keywords/local
#
# We do this by using enable_package which is a definition provided by the 'emerge' cookbook.
#
# =media-video/ffmpeg-0.6 
# =media-libs/openjpeg-1.3-r3 
#  =media-libs/opencore-amr-0.1.2 
#  =media-libs/x264-0.0.20100605 
#  =media-libs/libtheora-1.1.1 
#

directory "/usr/local/portage/overlay/ffmpeg" do
  action :create
  recursive true
  owner "root"
  group "root"
  mode 0755
end

remote_file "/usr/local/portage/overlay/ffmpeg.tar.gz" do
  source "ffmpeg.tar.gz"
  owner "root"
  group "root"
  mode 0755
  backup 0
end

execute "cd /usr/local/portage/overlay/ffmpeg/;tar zxfv /usr/local/portage/overlay/ffmpeg.tar.gz" do
  action :run
  not_if { FileTest.exists?("/usr/local/overlay/ffmpeg/profiles/repo_name") }
end

enable_package "media-video/ffmpeg" do
  version "0.6"
end

enable_package "media-libs/openjpeg" do
  version "1.3-r3"
end

enable_package "media-libs/opencore-amr" do
  version "0.1.2"
end

enable_package "media-libs/x264" do
  version "0.0.20100605"
end

enable_package "libtheora" do
  version "1.1.1"
end

execute "add_local_portage_to_make_conf" do
  command 'echo "PORTDIR_OVERLAY="$PORTDIR_OVERLAY /usr/local/portage/overlay/ffmpeg"">> /etc/make.conf'
  not_if "grep \"overlay/ffmpeg\" /etc/make.conf"
end

package "media-video/ffmpeg" do
  version "0.6"
  action :install
end
