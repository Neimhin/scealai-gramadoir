#!/usr/bin/perl -l
use Lingua::GA::Gramadoir;
use Encode qw( encode );
use JSON qw( to_json );
use utf8::all;
use CGI qw(-utf8);

binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";

my $gr = new Lingua::GA::Gramadoir();

my $q = CGI->new;
print $q->header("application/json;charset=UTF-8");
my $input = $q->param("text");

my $errs = $gr->grammatical_errors($input);

my @err_hash;
foreach my $err (@$errs) {
	
	(my $start, my $msg_ga, my $msg_en, $errorlength) = $err =~ m/.*fromx="([0-9]+)".*msg_ga="([^"]+)".*msg_en="([^"]+)".*errorlength="([0-9]+)"/;
	my $next = {
		msg_ga => $msg_ga,
		msg_en => $msg_en,
		start => $start,
		length => $errorlength
	};
	push @err_hash, $next;
}

print to_json(\@err_hash);

