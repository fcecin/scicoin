#!/usr/bin/perl

# Strict and warnings are recommended.
#use strict;
use warnings;


# if bad input print help and exit
$minargs = 10;
$maxargs = 11;
$bad = 0;
if (@ARGV < $minargs || @ARGV > $maxargs) { 
    $bad = 1; 
} else {
    
   # args
   $mode = lc $ARGV[0];
   $sourcecoin = $ARGV[1];
   $sourceticker = $ARGV[2];
   $sourceport = $ARGV[3];
   $sourcetestnetport = $ARGV[4];
   $coiname = $ARGV[5];
   $ticker = $ARGV[6];
   $port = $ARGV[7];
   $testnet_port = $ARGV[8];
   $seednodes = $ARGV[9];
   if (@ARGV < $maxargs) {
       $branchname = 'master';
   } else {
       $branchname = $ARGV[10];
   }

   # case versions sourcecoin
   $sourcecoin_lower = lc $sourcecoin;
   $sourcecoin_upper = uc $sourcecoin;
   $sourcecoin_upperfirst = ucfirst $sourcecoin_lower;

   # case versions targetcoin
   $coiname_lower = lc $coiname;
   $coiname_upper = uc $coiname;
   $coiname_upperfirst = ucfirst $coiname_lower;
   
   # build image file list
   @img = ();
   push(@img, "${coiname_lower}.icns");
   push(@img, "${coiname_lower}.png");
   push(@img, "${coiname_lower}_testnet.png");
   push(@img, "${coiname_lower}.ico");
   push(@img, "${coiname_lower}_testnet.ico");
   push(@img, "toolbar.ico");
   push(@img, "toolbar.png");
   push(@img, "toolbar_testnet.ico");
   push(@img, "toolbar_testnet.png");
   @img2 = ();
   push(@img2, "splash.png");
   push(@img2, "splash_testnet.png");
   @img3 = ();
   push(@img3, "${coiname_lower}.ico"); # FIXME: repeat, 32x32 instead of 64x64
   push(@img3, "favicon.ico");
   push(@img3, "scicoin16.png");
   push(@img3, "scicoin32.png");
   push(@img3, "scicoin64.png");
   push(@img3, "scicoin128.png");
   push(@img3, "scicoin256.png"); # FIXME: xpm versions of these five
      
   foreach (@img) {
       my $imgfn = $_;
       if (! -e $imgfn) {
	   print "ERROR: missing file $imgfn from current dir.\n";
	   $bad = 1;
       }
   }
   foreach (@img2) {
       my $imgfn = $_;
       if (! -e $imgfn) {
	   print "ERROR: missing file $imgfn from current dir.\n";
	   $bad = 1;
       }
   }
   foreach (@img3) {
       my $imgfn = $_;
       if (! -e $imgfn) {
	   print "ERROR: missing file $imgfn from current dir.\n";
	   $bad = 1;
       }
   }
} 
    
if ($bad) {
    print "\n";
    print "makeanycoin.perl: Clones a git 'coin' branch and then creates a clone of that 'coin' by tweaking the source.\n";
    print "\n";
    print "Where:\n";
    print "  <mode> is either 't' (test) or 'x' or whatever other char (not testing). Test mode requires a preexisting 'test_<sourcecoin>' dir.\n";
    print "  <sourcecoin> is the name of the source coin with camel case capitalization, e.g. BitCoin.\n";
    print "  <sourceticker> is the ticker of the source coin, e.g. 'BTC' for Bitcoin.\n";
    print "  <sourceport> is the IP port number of the sourcecoin's node.\n";
    print "  <sourcetestnetport> is the IP port number of the sourcecoin's testnet node.\n";
    print "  <coiname> is the name of your coin with camel case capitalization, e.g. SciCoin.\n";
    print "  <ticker> is your coin ticker, e.g. 'BTC' for Bitcoin.\n";
    print "  <port> is the IP port number of your coin node.\n";
    print "  <testnet_port> is the IP port number of your coin node for its testnet.\n";
    print "  <seednodes> hexadecimal ipv4 list of seed nodes in C++ array initialization format.\n";
    print "  [branchname] is the name of the source coin's git branch (default: 'master').\n";
    print "\n";
    print "Additionally, you need the following files in the current directory:\n";
    print "  <coiname>.icns : Mac icons (see Bitcoin's 'bitcoin.icns' file).\n";
    print "  <coiname>.png : 256x256x32\n";
    print "  <coiname>_testnet.png : 256x256x32\n";
    print "  <coiname>.ico : 48x48x32\n";
    print "  <coiname>_testnet.ico : 48x48x32\n";
    print "  toolbar.ico : 16x16x32\n";
    print "  toolbar.png : 16x16x32\n";
    print "  toolbar_testnet.ico : 16x16x32\n";
    print "  toolbar_testnet.png : 16x16x32\n";
    print "  splash.png : 480x320x32\n";
    print "  splash_testnet.png : 480x320x32\n";
    print "  favicon.ico : 16x16\n";
    print "  <coiname>16.png : 16x16\n";
    print "  <coiname>32.png : 32x32\n";
    print "  <coiname>64.png : 64x64\n";
    print "  <coiname>128.png : 128x128\n";
    print "  <coiname>256.png : 256x256\n";
    print "\n";
    print "Usage: makeanycoin.perl <mode> <sourcecoin> <sourceticker> <sourceport> <sourcetestnetport> <coiname> <ticker> <port> <testnet_port> <seednodes> [branchname]\n";
    print "\n";
    die;
}

# testing?
if ($mode eq 't') {
    print "WE ARE RUNNING IN TEST MODE.\n";
    if (!-e "test_${sourcecoin_lower}") {
	die "test_${sourcecoin_lower} subdir does not exist. Cannot proceed with test mode.\n";
    }
}

# hi
print "Will try to make coin named '$coiname'\n with ticker symbol '$ticker'\n with port '$port'\n testnet port '$testnet_port'\n seed nodes '$seednodes'\n from source coin '$sourcecoin'\n from source coin ticker '$sourceticker'\n and from $sourcecoin_upperfirst branch '$branchname'\n\n";

# check if source coin directory or $coiname directory already exist; both
# must not exist yet otherwise you have to run this script from somewhere
# else (i.e. create some empty subdir and go there and try again).
if (-e "$sourcecoin_lower") {
    print "$sourcecoin_lower subdir exists. Won't proceed even if it is a fresh copy that you want to use. We have to redownload it to be sure. Because I am a stupid script. Don't like it? Then fix me.\n";
    die;
}
if (-e $coiname_lower) {
    print "$coiname_lower subdir exists. Won't proceed. Delete that crap or move it elsewhere.\n";
    die;
}

if ($mode eq 't') {

    print "Duplicating test_${sourcecoin_lower} into ${sourcecoin_lower} (emulating a git clone)...\n";

    $result = system("cp -r test_{$sourcecoin_lower} {$sourcecoin_lower}");
    if ($result != 0) {
	die "cp failed. That's miserable.\n";
    }

} else {

    # clone a specific version (branch)
    print "Cloning {$sourcecoin_upperfirst} repository, branch $branchname...\n";
    
    # Download bitcoin to ./bitcoin
    $result = system("git clone -b $branchname https://github.com/${sourcecoin_lower}/${sourcecoin_lower}.git");
    print "Result of git clone system call: $result\n";
    if ($result != 0) {
	die "Result code wasn't zero. I am assuming the git clone failed. Aborting.\n";
    }
}

# rename ./bitcoin dir to ./$coiname
print "Renaming cloned ./${sourcecoin_lower} dir to ./$coiname_lower\n";
$result = system("mv ${sourcecoin_lower} $coiname_lower");
print "Result of 'mv ${sourcecoin_lower} $coiname_lower': $result\n";
if ($result != 0) {
    print "Result code wasn't zero. Assuming 'mv' failed. Aborting.\n";
}

# rename all files with $sourcecoin_lower in their names to $coiname_lower
@mvlist = ();
use File::Find;
find(\&do_something_with_file, "./$coiname_lower/");
sub do_something_with_file 
{
    my $fname = $_;
    my $anothername = $fname;
    $anothername =~ s/$sourcecoin_lower/$coiname_lower/;
    if ($anothername ne $fname) {
	push(@mvlist, $File::Find::dir);
	push(@mvlist, $fname);
	push(@mvlist, $anothername);
	#print "$File::Find::dir ; $fname ; $anothername\n";
    }
}

$renamecount = 0;
while (@mvlist > 0) {
    $dir = shift(@mvlist);
    $oldfn = shift(@mvlist);
    $newfn = shift(@mvlist);

    #print "rename $dir/$oldfn to $dir/$newfn ...\n";
    $result = system("mv $dir/$oldfn $dir/$newfn");
    if ($result != 0) {
	print "Failed system call to 'mv $dir/$oldfn $dir/$newfn': result code = $result. Aborting.\n";
	die;
    }
    $renamecount++;
}

print "Renamed $renamecount files.\n";

# replace image files in src/qt/res/icons
print "Replacing 'icon' image files ...\n";
foreach (@img) {
    my $imgfn = $_;
    $tehcmd = "cp $imgfn $coiname_lower/src/qt/res/icons/$imgfn";
    print "Executing: $tehcmd\n";
    $result = system($tehcmd);
    if ($result != 0) {
	print "Failed system call to '$tehcmd': result code = $result. Aborting.\n";
	die;
    }
}
print "Done replacing 'icon' image files.\n";

# replace image files in src/qt/res/images
print "Replacing 'image' image files ...\n";
foreach (@img2) {
    my $imgfn = $_;
    $tehcmd = "cp $imgfn $coiname_lower/src/qt/res/images/$imgfn";
    print "Executing: $tehcmd\n";
    $result = system($tehcmd);
    if ($result != 0) {
	print "Failed system call to '$tehcmd': result code = $result. Aborting.\n";
	die;
    }
}
print "Done replacing 'image' image files.\n";

# replace image files in share/pixmaps
print "Replacing 'pixmap' image files ...\n";
foreach (@img3) {
    my $imgfn = $_;
    $tehcmd = "cp $imgfn $coiname_lower/share/pixmaps/$imgfn";
    print "Executing: $tehcmd\n";
    $result = system($tehcmd);
    if ($result != 0) {
	print "Failed system call to '$tehcmd': result code = $result. Aborting.\n";
	die;
    }
}
print "Done replacing 'pixmap' image files.\n";

# code changes
print "Will now start fixing the code itself.\n";

# list of regexp transforms
@xfrom = (
#    "<source>The Bitcoin developers</source>\n(\\s*)<translation>(.*?)Bitcoin(.*?)</translation>",
    "nsche Freicoin",
    "The $sourcecoin_upperfirst developers",
    "if \\(\\!GetBoolArg\\(\\\"-dnsseed\\\", true",
    "$sourcetestnetport",
    "$sourceport",
    "____PLACEHOLDER____TESTNET____PORT____",
    "____PLACEHOLDER____MAIN____PORT____",
    "$sourcecoin",
    "$sourcecoin_lower",
    "$sourcecoin_upper",
    "$sourcecoin_upperfirst",
    "unsigned int pnSeed\\[\\] =\n\\{(.*)\\};",
    "____PROTECTED____BIT____COIN____NAME____",
    "$sourceticker",
    "if \\(\\!GetBoolArg\\(\\\"-checkpoints\\\", true",
    "if \\(pindex==NULL\\)",
    "LALALALALA_CANT_HEAR_YOU"
    );

@xto = (
#    "<source>The ____PROTECTED____BIT____COIN____NAME____ developers</source>\n\\1<translation>\\2____PROTECTED____BIT____COIN____NAME____\\3</translation>",
    "LALALALALA_CANT_HEAR_YOU",
    "The ____PROTECTED____BIT____COIN____NAME____ developers",
    "if (!GetBoolArg(\"-dnsseed\", false",
    "____PLACEHOLDER____TESTNET____PORT____",
    "____PLACEHOLDER____MAIN____PORT____",
    "$testnet_port",
    "$port",
    "$coiname",
    "$coiname_lower",
    "$coiname_upper",
    "$coiname_upperfirst",
    "unsigned int pnSeed[] = { $seednodes };",
    "$sourcecoin_upperfirst",
    "$ticker",
    "if (!GetBoolArg(\"-checkpoints\", false",
    "if (true)",
    "nsche Freicoin"
    );

if (@xfrom != @xto) {
    die "Broken script. Fix it.";
}

# foreach text file, try to apply all xfrom, xto simple transformations 

print "Will now change all text files (coin name, port, seed nodes and dnsseed option set to false by default).\n";

find( {wanted => \&modify_files, no_chdir => 1 }, $coiname_lower);
sub modify_files
{
    # will do all files, but here add exceptions to 
    #  optimize, etc. (e.g. exclude png, directories, ...)
    if (-d "$File::Find::name") { return; }
    if ($File::Find::name =~ /.png$/) { return; }
    if ($File::Find::name =~ /.icns$/) { return; }
    if ($File::Find::name =~ /.ico$/) { return; }
    if ($File::Find::name =~ /.bmp$/) { return; }
    if ($File::Find::name =~ /.xpm$/) { return; }
    if ($File::Find::name =~ /.svg$/) { return; }
    if ($File::Find::name =~ /.git/) { return; }
    
    # read the file
    local $/ = undef;
    open FILE, "$File::Find::name" or die "Couldn't open to read file: $!";
    my $code = <FILE>;
    close FILE;

    # modify the file
    my $numchanges = 0;

    # do the initial copyright "Sourcecoin" name protection
    #  since I can't figure out how to escape this above (FIXME)
    $numchanges += ($code =~ s|<source>The $sourcecoin_upperfirst developers</source>\n(\s*)<translation>(.*?)$sourcecoin_upperfirst(.*?)</translation>|<source>The ____PROTECTED____BIT____COIN____NAME____ developers</source>\n\1<translation>\2____PROTECTED____BIT____COIN____NAME____\3</translation>|mgs);

    # all other modifications that I managed to figure out how 
    #  to properly escape...
    for (my $i = 0; $i < @xfrom; $i++) {
	my $from = $xfrom[$i];
	my $to = $xto[$i];
	$numchanges += ($code =~ s|$from|$to|mgs);
    }

    # save the file if made any changes
    if ($numchanges > 0) {
	print "Writing $numchanges changes to $File::Find::name ...\n";
	open FILE, ">$File::Find::name" or die "Could't open to write file: $!";
	print FILE "$code";
	close FILE;
    }
}


