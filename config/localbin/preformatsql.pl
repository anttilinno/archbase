#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use v5.10;

my $sql = $ARGV[0];

my ( $sql_var ) = $sql =~ /EXECUTE\s(\w+).*USING/ms;
my ( $sql_param ) = $sql =~ /USING(.+)\;/ms;
$sql_param =~ s/\s+//g;

my @sql_params = split ',', $sql_param;

print "RAISE NOTICE 'SQL: %', $sql_var;";

my $final_dump = "RAISE NOTICE 'PARAMETERS: " . '%,' x (scalar @sql_params * 2) . "',";
$final_dump =~ s/%,'/%'/;

foreach ( @sql_params ) {
    $final_dump .= "pg_typeof($_),$_,";
}

$final_dump =~ s/,$/;/;

print $final_dump;
