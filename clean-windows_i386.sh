###########################################################################
# Clean the cross-compilation file outputs for the Windows_i386 (32 bits)
###########################################################################

NAME=libusb
ARCH=windows_i386
PACK_DIR=packages
BUILD_DIR=build_$ARCH
EXAMPLE=listdevs-example
PREFIX=$HOME/.$ARCH



# Remove the build directory
rm -f -r $BUILD_DIR

# Removed the packages generated
rm -f $PWD/$PACK_DIR/$NAME-$ARCH-*.tar.gz
rm -f $PWD/$PACK_DIR/$NAME-$ARCH-*.zip
rm -f $PWD/$PACK_DIR/$EXAMPLE-$ARCH-*.zip

#-- Remove the installed libusb
cd $PREFIX
rm -f $PREFIX/bin/libusb-1.0.dll
rm -f -r $PREFIX/include/libusb-1.0
rm -f $PREFIX/lib/libusb-1*
rm -f $PREFIX/lib/pkgconfig/libusb-1*
