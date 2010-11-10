enable_package "x11-libs/qt-svg" do
  version "4.4.2"
end

enable_package "x11-libs/qt-gui" do
  version "4.4.2"
end

enable_package "x11-libs/qt-core" do 
version "4.4.2" 
end

enable_package "x11-libs/qt-qt3support" do 
version "4.4.2" 
end

enable_package "x11-libs/qt-sql" do 
version "4.4.2" 
end

enable_package "x11-libs/qt-sgl" do
  version "4.4.2"
end

enable_package "x11-libs/qt-webkit" do 
version "4.4.2" 
end

enable_package "x11-libs/qt-gui-4.4.2" do 
version "4.4.2" 
end

enable_package "x11-libs/qt-script" do 
version "4.4.2" 
end

enable_package "dev-python/PyQt4" do 
version "4.4.3" 
end

enable_package "dev-python/sip" do 
version "4.7.7" 
end

# these files are here because I could not get this file with the proxy enabled
# not required already updated on the proxy :)
#remote_file "/engineyard/portage/distfiles/sip-4.7.7.tar.gz" do 
#source "http://service-spi.web.cern.ch/service-spi/external/tarFiles/sip-4.7.7.tar.gz"; 
#backup 0 
#end

#remote_file "/engineyard/portage/distfiles/PyQt-x11-gpl-4.4.3.tar.gz" do 
#source "http://ancient-distfiles.s3.amazonaws.com/PyQt-x11-gpl-4.4.3.tar.gz"; 
#backup 0 
#end

package "dev-python/PyQt4" do 
version "4.4.3" 
action :install 
end

package "x11-libs/qt-webkit" do
  version "4.4.2"
  action :install
end
