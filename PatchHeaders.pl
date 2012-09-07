#!/usr/bin/env perl

# Patches all of the import commands in headers to point to the correct framework.

my $desktop = $ARGV[0];

use File::Find;
use File::Path;

sub getDesktop {
    return $desktop;
}

sub genheadertable {
    if (/\.h$/) {
        my $position = rindex($File::Find::dir, "/") +1;
        my $framework = substr($File::Find::dir, $position);
        $framework =~ s/\.framework//i;
        my $import = "\#import \<$framework\/" . $_ . "\> \n";
        if ($import =~ /\#import \<CoreFoundation\/NSObject.h\>/i)
        {
            $import =~ s/\#import \<CoreFoundation\/NSObject.h\>/\#import \<Foundation\/NSObject.h\>/i;
        }
        print OUTPUT $import; 
    }
}

sub readheaders {
    if (/\.h$/) {
        my $headerfile = $File::Find::name;
        my $headerpath = $File::Find::dir;
        $headerpath =~ s/HeaderDump/PatchedHeaderDump/;
        $newheaderpath = $headerpath . "\/Headers\/";
        my $newheaderfile = $newheaderpath . "/" . $_;
        if (-d "$newheaderpath") {
        } else {
            mkpath("$newheaderpath");
        }
        open NEWHEADER, ">$newheaderfile" or die $!;
        open HEADER, "$headerfile" or die $!; @headerlines = <HEADER>; close HEADER;
        foreach $headerline (@headerlines) {
            if ($headerline =~ /\#import/i) {
                if (!($headerline =~ /\#import \</i) && !($headerline =~ /-/) && !($headerline =~ /CDStructures/i)) {
                    $headerline =~ s/(\#import \")(.*)(\")/(patchheader($2))/ei;
                    chomp($headerline); 
                }
            }
            print NEWHEADER $headerline;
        }
    }
}

sub patchheader {
    my $findstring = $_[0];
    my $foundcount = 0; my $foundresult = "";
    foreach $htline (@htlines) {
        my $searchstring = "\/" . $findstring . "\>";
        if($htline =~ /$searchstring/i) {
            $foundcount++; $foundresult = $htline;
        }
    }
    if ($foundcount == 0) {
        print $findstring . " was not found.\n"; return $findstring;
    } elsif ($foundcount > 1) {
        return $foundresult;
        #print $findstring . " was found multiple times. Unable to determine the correct one to use.\n"; return $findstring;
    } elsif ($foundcount == 1) {
        return $foundresult;
    } else {
        print "Unknown error occured with search for header: " . $findstring . "\n"; return $findstring;
    }
}

my $headertable = getDesktop() . "headers.h";
my $searchpath = getDesktop() . "HeaderDump/";

open OUTPUT, ">>$headertable" or die $!;
find(\&genheadertable, "$searchpath");
print OUTPUT "\#import \<Foundation\/NSObject.h\>";
close OUTPUT;

open HT,"$headertable"; @htlines = <HT>; close(HT);
find(\&readheaders, "$searchpath");
