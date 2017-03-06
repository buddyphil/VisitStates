#!C:\Strawberry\perl\bin\perl.exe

use DBI;
use CGI ;
use Data::Dumper;
use JSON;
use strict;
use warnings;

my $q = CGI->new();

my $state = $q->param('state');

sub _db_connect {	#connect to mysql database
	my $host = "127.0.0.1";
	my $user = "root";
	my $password = "";
	my $port = 3306;
	my $db = "dev1";
	#connect to server and database
	my $dbh = DBI->connect("DBI:mysql:database=$db;host=$host;port=$port","$user","$password");
	return ($dbh);
}

my $dbh = _db_connect();

sub _get_states {	#get list of all states in 'states' table

	my $sts = $dbh->selectall_arrayref("SELECT state FROM states");
	my @states = map {
		$_->[0];
		} @$sts;
	
	$dbh->disconnect();

	return (\@states);
}

sub _get_vis_states {	#get last of states in 'visited' table

	my $sts = $dbh->selectall_arrayref("SELECT state FROM visited");
	my @states = map {
		$_->[0];
		} @$sts;
	
	$dbh->disconnect();

	return (\@states);
}

#getting list of all states to send to javascript
if ( $q->param('ajaxAction') eq "get_states" ) {
	my $states = _get_states();
	
    my $json = to_json($states);
    print $q->header('application/json');
    print $json;
    exit(0);

}

#adding states to the visited table and getting the updated list back
if ( $q->param('ajaxAction') eq "add_state" ) {
logit(" state is",$state);
	
	my $sth = $dbh->prepare("SELECT COUNT(*) FROM visited WHERE state = ?");
	$sth->execute($state);
	my $count = $sth->fetchrow;
	if (!$count) {
		$sth = $dbh->prepare("INSERT INTO visited VALUES(?)");
		$sth->execute($state);
	}
	$sth->finish();
	$dbh->disconnect();
	my $states = _get_vis_states();
	
    my $json = to_json($states);
    print $q->header('application/json');
    print $json;

	exit(0);

}

#removing states from the visited table and getting the updated list back
if ( $q->param('ajaxAction') eq "remove_state" ) {

	my $sth = $dbh->prepare("DELETE FROM visited WHERE state = ?");
	$sth->execute($state);
	
	$dbh->disconnect();
	my $states = _get_vis_states();

    my $json = to_json($states);
    print $q->header('application/json');
    print $json;
    exit(0);
}

#clear visited table and getting the updated list back
if ( $q->param('ajaxAction') eq "clear_visited" ) {

	$dbh->do("DELETE FROM visited");
	$dbh->disconnect();

 	my $states = _get_vis_states();

    my $json = to_json($states);
    print $q->header('application/json');
    print $json;
   
	exit(0);
}

#getting list of visited states to send to javascript
if ( $q->param('ajaxAction') eq "get_visited" ) {

	$dbh->disconnect();
	my $states = _get_vis_states();
	
    my $json = to_json($states);
    print $q->header('application/json');
    print $json;
    exit(0);
}

#personal log sub function
sub logit {
    my $str = shift;
    open(LOG,">>/home/philparisoe/phil.log");
    print LOG "\n" . $str . "\n";
    close LOG;
}