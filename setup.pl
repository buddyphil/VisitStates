#!C:\Strawberry\perl\bin\perl.exe

use DBI;
use CGI ;
use Data::Dumper;

my $host = "127.0.0.1";
my $user = "root";
my $password = "";
my $port = 3306;
my $db = "dev1";

#connect to server and database
my $dbh = DBI->connect("DBI:mysql:database=$db;host=$host;port=$port","$user","$password");

#get rid of old states table
$dbh->do(
	"DROP TABLE IF EXISTS states");
	
#create new states table
$dbh->do(
	"CREATE TABLE states (
		state varchar(32) NOT NULL,
		PRIMARY KEY (state)
		);"
	);
	
#get rid of old vistited table
$dbh->do(
	"DROP TABLE IF EXISTS visited");
	
#create new visted table
$dbh->do(
	"CREATE TABLE visited (
		state varchar(32) NOT NULL,
		PRIMARY KEY (state)
		);"
	);
	
#create list of states to visit
@states = qw(Alabama Alaska Arizona Arkansas California Colorado Connecticut Delaware Florida Georgia Hawaii Idaho Illinois Indiana Iowa Kansas Kentucky Louisiana Maine Maryland Massachusetts Michigan Minnesota Mississippi Missouri Montana Nebraska Nevada New_Hampshire New_Jersey New_Mexico New_York North_Carolina North_Dakota Ohio Oklahoma Oregon Pennsylvania Rhode_Island South_Carolina South_Dakota Tennessee Texas Utah Vermont Virginia Washington West_Virginia Wisconsin Wyoming);
for(@states){s/_/ /g};

foreach my $state(@states) {
	$sth = $dbh->prepare("INSERT INTO states VALUES(?)");
	$sth->execute($state);
}

#html stuff
my $q = CGI->new();
print $q->header(), $q->start_html();

print "If you are reading this message... \n<br> the 'states' and 'visited' tables on mysql have been re-set.";
=showtables
my $tbls = $dbh->selectall_arrayref("SHOW TABLES");
print "Number of tables = ", scalar(@$tbls), "\n<br>";
foreach my $tbl (@$tbls) {
	print "$tbl->[0] \n<br>";
}	

print "\n<br>";
=cut

print $q->end_html();


