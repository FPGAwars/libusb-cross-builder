##############################################
# libusb builder for Linux 32 bits           #
##############################################

# NOTE: This cross-compilation of the libusb library has been created as an
#  example of cross-compiling from linux-64 to linux-32. Nevertheless,
#  it is not necesary to compile this library for other programas
#    The libusb i386 can be obtained with the following command:
#    sudo apt-get install libusb-1.0:i386

BUILD=x86-unknown-linux-gnu
HOST=i686-linux-gnu
TARGET=i686make-linux-gnu


NAME=libusb
ARCH=linux_i686
PREFIX=$HOME/.$ARCH
VERSION=4
PACKNAME=$NAME-$ARCH-$VERSION
BUILD_DIR=build_$ARCH
PACK_DIR=packages

TARBALL=$PWD/$BUILD_DIR/$PACKNAME.tar.gz
ZIPBALL=$PWD/$BUILD_DIR/$PACKNAME.zip
ZIPEXAMPLE=listdevs-example-$ARCH-$VERSION.zip

GITREPO=https://github.com/libusb/libusb.git



# Store current dir
WORK=$PWD

# Install dependencies
echo "Instalando DEPENDENCIAS:"
sudo apt-get install mingw-w64 libtool autoconf gcc-multilib g++-multilib libudev-dev:i386 libudev1:i386

# Clone the libusb repo
git -C $NAME pull || git clone $GITREPO

# Create the packages directory
mkdir -p $PACK_DIR

# Enter into the build directory
mkdir -p $BUILD_DIR ; cd $BUILD_DIR

# Copy the upstream libusb into the build dir
cp -r $WORK/$NAME .

# Prepare for building
cd $NAME
./autogen.sh

# Configure cross compilation
./configure --host=i686-linux-gnu "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32"  --prefix=$PREFIX

# let's cross compile!
make

# Install libusb
make install

# Cross-compile one example
cd examples
gcc -m32 -o listdevs listdevs.c -I $HOME/.linux_i686/include/libusb-1.0  -L /lib/i386-linux-gnu/  $HOME/.linux_i686/lib/libusb-1.0.a -lpthread -ludev

# Zip the .exe file and move it to the main directory
zip $ZIPEXAMPLE listdevs.exe
mv $ZIPEXAMPLE $WORK/$PACK_DIR

# Create the tarball
cd $PREFIX
tar vzcf $TARBALL *
mv $TARBALL $WORK/$PACK_DIR

# Create the zipball
zip -r $ZIPBALL *
mv $ZIPBALL $WORK/$PACK_DIR
