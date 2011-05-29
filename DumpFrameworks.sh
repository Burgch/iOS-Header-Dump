#!/bin/bash

# Dumps all of the iOS frameworks (both public and private) and then patches the imports.
# The headers are then merged with the existing iOS headers in your SDK.

# Takes one argument: 
# The SDK Path (e.g. "/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS4.3.sdk")
# class-dump must be located in "/usr/bin/class-dump"

SDK=$1

# Initial set up

rm -rf ~/Desktop/HeaderDump
mkdir ~/Desktop/HeaderDump
mkdir ~/Desktop/HeaderDump/Frameworks
mkdir ~/Desktop/HeaderDump/PrivateFrameworks

# Dump Public Frameworks

for fw in $SDK/System/Library/Frameworks/*/
do
    class-dump --arch armv6 --arch armv7 -H -o ~/Desktop/HeaderDump/Frameworks/$(perl -e "print substr(substr('$fw', 0, -1), rindex(substr('$fw', 0, -1), \"/\") +1, (rindex(substr('$fw', 0, -1), \".\"))-(rindex(substr('$fw', 0, -1), \"/\") +1))";).framework/ $fw$(perl -e "print substr(substr('$fw', 0, -1), rindex(substr('$fw', 0, -1), \"/\") +1, (rindex(substr('$fw', 0, -1), \".\"))-(rindex(substr('$fw', 0, -1), \"/\") +1))";)
done

# Dump Private Frameworks

for pfw in $SDK/System/Library/PrivateFrameworks/*/
do
    class-dump --arch armv6 --arch armv7 -H -o ~/Desktop/HeaderDump/PrivateFrameworks/$(perl -e "print substr(substr('$pfw', 0, -1), rindex(substr('$pfw', 0, -1), \"/\") +1, (rindex(substr('$pfw', 0, -1), \".\"))-(rindex(substr('$pfw', 0, -1), \"/\") +1))";).framework/ $pfw$(perl -e "print substr(substr('$pfw', 0, -1), rindex(substr('$pfw', 0, -1), \"/\") +1, (rindex(substr('$pfw', 0, -1), \".\"))-(rindex(substr('$pfw', 0, -1), \"/\") +1))";)
done

# Dump SpringBoard

class-dump --arch armv6 --arch armv7 -H $SDK/System/Library/CoreServices/SpringBoard.app/SpringBoard -o ~/Desktop/HeaderDump/PrivateFrameworks/SpringBoard.framework	

# Patch Headers

perl ./PatchHeaders.pl

# Merge with Apple Headers

sudo cp -Rn ~/Desktop/PatchedHeaderDump/Frameworks/ $SDK/System/Library/Frameworks
sudo cp -Rn ~/Desktop/PatchedHeaderDump/PrivateFrameworks/ $SDK/System/Library/PrivateFrameworks
sudo cp ./substrate.h $SDK/System/Library/PrivateFrameworks
sudo cp ./libsubstrate.dylib $SDK/usr/lib

# Tidy Up

rm -rf ~/Desktop/HeaderDump
rm -rf ~/Desktop/PatchedHeaderDump
rm ~/Desktop/headers.h

exit 0