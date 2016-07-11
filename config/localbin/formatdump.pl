#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use v5.10;

use Data::Dumper::Concise;

undef $/;
open my $fh, '<:utf8', $ARGV[0];
my $sql_dump = <$fh>;
close $fh;

my ( $sql, $params ) = $sql_dump =~ /NOTICE:\s*SQL:(.*?)NOTICE:.*PARAMETERS:\s(.*?)\n/ms;

chomp $sql;
chomp $params;

my @params = split /,/, $params;

my $i = ( scalar @params / 2 ) + 1;

while ( @params ) {
    my $param_value = pop @params;
    my $param_type  = pop @params;

    $i--;
    my $new_val;
    if ( $param_value eq '<NULL>' ) {
        $new_val = "NULL::$param_type";
    }
    else {
        $new_val = "'$param_value'::$param_type";
    }
    my $old_val = '$' . $i;
    $sql =~ s/\Q$old_val/$new_val/msg;
}

say $sql;
