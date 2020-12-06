#!/usr/bin/perl
use strict;
use warnings;
use autodie;

my $definitions = "/opt/sites/crossstitch.info/";
my $webserver   = "/webserver/crossstitch/";
my $resources   = $definitions . "resources/";
my $content     = "";
my $target      = "${definitions}bin/";

system("rm -rf $target");
system("mkdir -p $target");

my $entries = "";
for my $image (
`find $resources -type f -printf '%f\\t%p\\n' | sort -k1 | cut -d '\t' -f2 | grep -v "\.pdf"`
  )
{
    chomp $image;
    $image =~ s#$definitions##g;
    my $generic = `echo $image | cut -d '.' -f 1`;
    chomp $generic;
    my $name = `basename $generic`;
    chomp $name;
    my $pdf  = $generic . ".pdf";
    my $link = "(pattern unavailable)";

    if ( -e "$definitions$pdf" ) {
        $link = "<a href='$pdf'>(pdf)</a>";
    }
    my $div =
"<div class='entry'><p>$name $link</p><img src='$image' alt='$name' /></a></div>";
    $entries = $entries . "\n" . $div;
}

my $output = "";
open( my $INDEX, '<', "${definitions}index.html" );
while (<$INDEX>) {
    $output = $output . "$_";
}

$output =~ s/{CONTENT}/$entries/g;
open( my $OUT, ">", "${target}index.html" );
print $OUT $output;
system("cp $definitions/main.css $target");
system("cp -r $resources ${target}resources");
system("rsync -arcv --delete-after $target $webserver");
