#!/usr/bin/perl
use strict;
use warnings;
use autodie;

my $definitions = "/opt/whoami/crossstitch.info/";
my $webserver   = "/webserver/crossstitch/";
my $resources   = $definitions . "resources/";
my $content     = "";
my $target      = "${definitions}bin/";

system("rm -rf $target");
system("mkdir -p $target");

my @pages;
my $page    = 1;
my $count   = 0;
my $entries = "";
for my $dir (`ls $resources | sort -r`) {
    chomp $dir;
    if ( !$dir ) {
        next;
    }
    for
      my $image (`find $resources$dir -type f -print | sort  | grep -v "\.pdf"`)
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
"<div class='entry'><p>$name ($dir) $link</p><a href='$image'><img src='$image' loading='lazy' alt='$name' /></a></div>";
        $entries = $entries . "\n" . $div;
        if ( $count > 50 ) {
            push @pages, $entries;
            $entries = "";
            $page += 1;
            $count = -1;
        }
        $count += 1;
    }
}

if ($entries) {
    push @pages, $entries;
}

my %page_files;
my $idx = 0;
my @links;
for my $file (@pages) {
    my $file_name = "page$idx";
    my $disp      = $file_name;
    if ( $idx == 0 ) {
        $file_name = "index";
        $disp      = "home";
    }
    $idx += 1;
    $page_files{$file_name} = $file;
    push @links, "<a href='$file_name.html'>$disp</a>";
}

my $output = "";
open( my $INDEX, '<', "${definitions}index.html" );
while (<$INDEX>) {
    $output = $output . "$_";
}

my $date = `date +%Y-%m-%d`;
for my $file ( keys %page_files ) {
    chomp $date;
    my $show = "detail-hide";
    if ( $file =~ m/index/ ) {
        $show = "detail-show";
    }
    my $entries = $page_files{$file};
    my $map     = join( "\n", @links );
    $map = `echo '$map' | grep -v $file`;
    my $tmpl = $output;
    $tmpl =~ s/{CONTENT}/$entries/g;
    $tmpl =~ s/{DATE}/$date/g;
    $tmpl =~ s/{LINKS}/$map/g;
    $tmpl =~ s/{CLASS}/$show/g;
    open( my $OUT, ">", "${target}$file.html" );
    print $OUT $tmpl;
}

system("cp $definitions/main.css $target");
system("cp -r $resources ${target}resources");
system("rsync -arcv --delete-after $target $webserver");
