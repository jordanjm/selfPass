#! /usr/bin/perl
###############################################################################
#
#    Email Manager
#    
#    This program manages a email system database.  It is designed to manage 
#    an email server set up using the following tutorial:
#
#    https://www.linode.com/docs/email/postfix/email-with-postfix-dovecot-and-
#    mariadb-on-centos-7
#
#    Copyright (C) Jordan McGilvray
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#################################################################################

use strict;
use warnings;
use 5.010;
use DBI;
use Term::ANSIColor;
use Term::ReadKey;

#Get the Database Connection Info From the .connect file and return it.
#INPUT: Contents of .connect file, On each line: database name database user database user password
#OUTPUT: NONE
#RETURNS: Database name, Database User, Database User Password
sub dbInfo
{
	open FILE, ".connect" or die $!;
	my @dbConnect = <FILE>;
	chomp (@dbConnect);
	close FILE;
	return @dbConnect;
}

#Creates the database tables for installing the 
#INPUT: database connection Info
#OUTPUT: NONE
#RETURNS: NONE
#DB Structure:
#	Email Table (email):	ID, Name, Username, Email Address, Password, Note(Note ID)
#	Website Table (web):	ID, Name, Username, Password, URL, LoginURL, Note(Note ID) 
#	System Table (system):	ID, Name, Username, Hostname, Note(Note ID)
#	Notes Table (note):	ID, Title, Note, Date/Time Stamp
sub createTables
{
	#Get The DB Connection Info
	my @dbConnect = dbInfo();
	#Open the DB Connection
        my $dbh = DBI->connect("DBI:mysql:$dbConnect[0]", "$dbConnect[1]", "$dbConnect[2]"                                                                                                                                         ) || die "Could Not Connect to Database: $DBI::errstr";
	#Create the email table
	my $sql = qq { CREATE TABLE [IF NOT EXISTS] email(ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR, email VARCHAR, password VARCHAR, note INT) engine=table_type") };
	my $sth = $dbh->prepare( $sql );
	$sth->execute();
	$sth->finish();
	#Create the website table
	$sql = qq { CREATE TABLE [IF NOT EXISTS] web(ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR, user VARCHAR, password VARCHAR, url VARCHAR, login VARCHAR, note INT) };
	$sth = $dbh->prepare( $sql );
	$sth->execute();
	$sth->finish();
	#Create the system table
	$sql = qq { CREATE TABLE [IF NOT EXISTS] system(ID BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR, user VARCHAR, host VARCHAR, note INT)  };
        $sth = $dbh->prepare( $sql );
        $sth->execute();
        $sth->finish();
	#Create the notes table
	$sql = qq { CREATE TABLE [IF NOT EXISTS] note(ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY, title VARCHAR, note VARCHAR, date TIMESTAMP) };
        $sth = $dbh->prepare( $sql );
        $sth->execute();
        $sth->finish();
	#Close the DB Connection
	$dbh->disconnect();
}

sub main
{
	createTables();
}

main ();
