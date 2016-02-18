##############################################
# libusb builder for different architectures #
##############################################

BUILD=x86-unknown-linux-gnu
HOST=i686-w64-mingw32
TARGET=i686-w64-mingw32
PREFIX=$HOME/.win/libusb


NAME=libusb
ARCH=windows
VERSION=1
PACKNAME=$NAME-$ARCH-$VERSION
TARBALL=$PWD/dist/$PACKNAME.tar.gz

# Store current dir
WORK=$PWD

# Enter into the code directory
mkdir -p dist; cd dist

# Install dependencies
sudo apt-get install mingw-w64

# download libusb
git -C libusb pull || git clone https://github.com/libusb/libusb.git

# Prepare for building
cd libusb
./autogen.sh

# Configure cross compilation
./configure --build=$BUILD --host=$HOST --target=$TARGET --prefix=$PREFIX

# let's cross compile!
make

# Install libusb
make install

# Create the tarball
cd $PREFIX
tar vzcf $TARBALL *
mv $TARBALL $WORK
