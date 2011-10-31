Copyright (C) 2011  Conor Burgess

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

******************************************* DESCRIPTION *****************************************************

These scripts dump all of the iOS frameworks (both public and private) and then patch the #import commands.

The headers are then merged with the existing iOS headers in your SDK, without overwriting any Apple headers.

****************************************** PRE-REQUISITES ****************************************************

You will need to download class-dump from: http://www.codethecode.com/projects/class-dump/ and then copy just the executable to "/usr/bin/" on your Mac.

You will also need to download subtrate.h from here: http://svn.saurik.com/repos/menes/trunk/mobilesubstrate/substrate.h and place it in the same folder as the scripts.

You will need to copy libsubstrate.dylib from /usr/lib/libsubstrate.dylib on a jailbroken iOS device with MobileSubstrate installed to the same folder as the scripts and substrate.h on your Mac.

******************************************** USAGE ***********************************************************

cd to the directory with the scripts and substrate.h in:

Burgch$ cd /Users/Burgch/Desktop/DumpFrameworks

The script takes one argument; the SDK directory for the SDK you would like to dump.

Run the script:

Burgch$ ./DumpFrameworks.sh /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS4.3.sdk

When prompted, enter your super user password (this is required to copy the header files back to the SDK (you can check the script if you don't believe me :P)

That's it, you're done, all header files for the SDK have been dumped, patched, and merged. Wasn't that easy :P

******************************************* NOTES ************************************************************

Tested and confirmed to work on firmwares 3.X - 5.X
