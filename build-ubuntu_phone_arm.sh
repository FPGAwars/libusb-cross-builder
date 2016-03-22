##################################################
# libusb builder for Ubuntu phone (ARM 32 bits   #
##################################################

# NOTE: This cross-compilation of the libusb library has been created as an
#  example of cross-compiling from linux-64 to linux-32. Nevertheless,
#  it is not necesary to compile this library for other programas
#    The libusb i386 can be obtained with the following command:
#    sudo apt-get install libusb-1.0:i386

BUILD=x86-unknown-linux-gnu
HOST=arm-linux-gnueabihf
TARGET=arm-linux-gnueabihf


NAME=libusb
ARCH=armhf
PREFIX=$HOME/.$ARCH
VERSION=4
PACKNAME=$NAME-$ARCH-$VERSION
BUILD_DIR=build_$ARCH
BUILD_DATA=build-data
PACK_DIR=packages

TARBALL=$PWD/$BUILD_DIR/$PACKNAME.tar.gz
ZIPBALL=$PWD/$BUILD_DIR/$PACKNAME.zip
ZIPEXAMPLE=listdevs-example-$ARCH-$VERSION.tar.gz

GITREPO=https://github.com/libusb/libusb.git



# Store current dir
WORK=$PWD

# -- TARGET: CLEAN. Remove the build dir and the generated packages
# --  then exit
if [ "$1" == "clean" ]; then
  echo "-----> CLEAN"

  # Remove the build directory
  rm -f -r $BUILD_DIR

  # Removed the packages generated
  rm -f $PWD/$PACK_DIR/$NAME-$ARCH-*.tar.gz
  rm -f $PWD/$PACK_DIR/$NAME-$ARCH-*.zip
  rm -f $PWD/$PACK_DIR/$EXAMPLE-$ARCH-*.zip

  #-- Remove the installed libusb
  cd $PREFIX 2> /dev/null
  rm -f -r $PREFIX/include/libusb-1.0
  rm -f $PREFIX/lib/libusb-1*
  rm -f $PREFIX/lib/pkgconfig/libusb-1*

  exit
fi


# Install dependencies
echo "Instalando DEPENDENCIAS:"
sudo apt-get install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
                     libtool autoconf

# Clone the libusb repo
git -C $NAME pull || git clone $GITREPO

# Create the packages directory
mkdir -p $PACK_DIR

# Enter into the build directory
mkdir -p $BUILD_DIR ; cd $BUILD_DIR

# Copy the upstream libusb into the build dir
cp -r $WORK/$NAME .

# Patch the original package
cp $WORK/$BUILD_DATA/$ARCH/configure.ac $WORK/$BUILD_DIR/$NAME

# Prepare for building
cd $NAME
./autogen.sh

# Configure cross compilation
./configure --build=$BUILD --host=$HOST --target=$TARGET --prefix=$PREFIX

# let's cross compile!
make

# Create the destination directories
mkdir -p $PREFIX
mkdir -p $PREFIX/lib
mkdir -p $PREFIX/lib/pkgconfig
mkdir -p $PREFIX/include
mkdir -p $PREFIX/include/libusb-1.0

# Copy the library and .h files
cp $NAME/.libs/libusb-1.0.a $PREFIX/lib
cp $NAME/.libs/libusb-1.0.so $PREFIX/lib
cp $NAME/.libs/libusb-1.0.so.0 $PREFIX/lib
cp libusb-1.0.pc $PREFIX/lib/pkgconfig
cp $NAME/libusb.h $PREFIX/include/libusb-1.0

# Copy some libraries for building the example
cp $WORK/$BUILD_DATA/$ARCH/libpthread.so.0 $PREFIX/lib
cp $WORK/$BUILD_DATA/$ARCH/libudev.so.1 $PREFIX/lib

# Cross-compile one example
cd examples
arm-linux-gnueabihf-gcc -o listdevs listdevs.c -I $HOME/.armhf/include/libusb-1.0  -L $HOME/.armhf/lib $HOME/.armhf/lib/libusb-1.0.a -lpthread

# Zip the .exe file and move it to the main directory
tar vzcf $ZIPEXAMPLE listdevs
mv $ZIPEXAMPLE $WORK/$PACK_DIR

# Create the tarball
cd $PREFIX
tar vzcf $TARBALL *
mv $TARBALL $WORK/$PACK_DIR

# Create the zipball
zip -r $ZIPBALL *
mv $ZIPBALL $WORK/$PACK_DIR
