##############################################
# libusb builder for Windows 64 bits         #
##############################################

BUILD=x86-unknown-linux-gnu
HOST=x86_64-w64-mingw32
TARGET=x86_64-w64-mingw32


NAME=libusb
ARCH=windows_x86_64
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
sudo apt-get install mingw-w64 libtool autoconf

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
./configure --build=$BUILD --host=$HOST --target=$TARGET --prefix=$PREFIX

# let's cross compile!
make

# Install libusb
make install

# Cross-compile one example
cd examples
$HOST-gcc -o listdevs.exe listdevs.c -I $PREFIX/include/libusb-1.0 -L $PREFIX/lib -static -lusb-1.0

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
