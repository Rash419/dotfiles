set -e

echo "Setting up Collabora Online and Core..."
echo "Installing core dependencies..."
yay -S --noconfirm 'base-devel' 'git' 'ccache' 'ant' 'apr' 'beanshell' 'bluez-libs' 'clucene' \
                        'coin-or-mp' 'cppunit' 'curl' 'dbus-glib' \
                        'desktop-file-utils' 'doxygen' 'flex' 'gcc-libs' \
                        'gdb' 'glm' 'gobject-introspection' 'gperf' 'gpgme' \
                        'graphite' 'gst-plugins-base-libs' 'gtk3' \
                        'harfbuzz-icu' 'hicolor-icon-theme' 'hunspell' \
                        'hyphen' 'icu' 'java-environment' 'junit' \
                        'lcms2' 'libabw' 'libatomic_ops' 'libcdr' 'libcmis' \
                        'libe-book' 'libepoxy' 'libepubgen' 'libetonyek' \
                        'libexttextcat' 'libfreehand' 'libgl' 'libjpeg' \
                        'liblangtag' 'libmspub' 'libmwaw' 'libmythes' \
                        'libnumbertext' 'libodfgen' 'liborcus' 'libpagemaker' \
                        'libqxp' 'libstaroffice' 'libtommath' 'libvisio' \
                        'libwpd' 'libwpg' 'libwps' 'libxinerama' 'libxrandr' \
                        'libxslt' 'libzmf' 'lpsolve' 'mariadb-libs' \
                        'mdds' 'nasm' 'neon' 'nspr' 'nss' 'pango' \
                        'plasma-framework5' 'poppler' 'postgresql-libs' \
                        'python' 'qt5-base' 'redland' 'sane' 'serf' 'sh' \
                        'shared-mime-info' 'ttf-liberation' 'unixodbc' \
                        'unzip' 'xmlsec' 'zip' 'gtk4' 'qt6-base' 'zxing-cpp' \
                        'abseil-cpp' 'meson'

yay -S --noconfirm libcap libcap-ng lib32-libcap libpng poco \
          cppunit nodejs npm chromium python-lxml python-polib

COLLABORA_DIR="/home/$USER/collabora"
mkdir -p "$COLLABORA_DIR/online"
mkdir -p "$COLLABORA_DIR/core"

echo "Cloning and building libreoffice core..."
cd "$COLLABORA_DIR/core"
git clone https://gerrit.libreoffice.org/core co-2504
cd co-2504
git checkout distro/collabora/co-25.04
./autogen.sh --enable-dbgutil --without-system-nss --without-junit
make PARALLELISM=12

echo "Cloning and building collabora online..."
cd "$COLLABORA_DIR/online"
git clone https://github.com/CollaboraOnline/online master
cd master
./autogen.sh
./configure --enable-silent-rules --with-lokit-path=${COLLABORA_DIR}/core/co-2504/include \
            --with-lo-path=${COLLABORA_DIR}/core/co-2504/instdir \
            --enable-debug --enable-cypress --enable-feature-lock
make -j $(nproc)
