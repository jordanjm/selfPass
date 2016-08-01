#! /usr/bin/perl
###############################################################################
#
#    Password Generator
#
#    This program generates a (psuedo) random password.  It takes flags to
#    set its values.  
#
#    You can set the length of the password, and what characters to include
#    Uppercase Letters, Lowercase Letters, Numbers, Special Characters,
#    Brackets, and the space character
#
#    Defaults are 20 characters long using all characters but the space
#    character.    
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
use Getopt::Long;

#Defines the flags and takes in their values
#INPUT: Password Length, Default 20, and Boolean Values
#Output: None
#RETURNS: Array of values.
sub flagsIn
{
	my $length = 20;
	my $capitalLetters = 0;
	my $lowerLetters = 0;
	my $numbers = 0;
	my $specialCharacters = 0;
	my $brackets = 0;
	my $space = 0;
	my $help = 0;
	#Define Command Line Flags, both long and short values are defined.
	GetOptions(
		"length|l=i"	=> \$length,		#Password Length
		"capital|c"	=> \$capitalLetters, 	#Include Capital Letters
		"lower|o"	=> \$lowerLetters,	#Include Lowercase Letters
		"numbers|n"	=> \$numbers,		#Include Numbers
		"characters|a"	=> \$specialCharacters,	#Include !@#\$\%^&*-_=+\\|;:'\",./?
		"brackets|b"	=> \$brackets,		#Include []{}()<>
		"space|s"	=> \$space,		#Include the space character in the backups
		"help|h"	=> \$help)		#Display help for the generator
	or die("Error in arguments\n");
	#Define and generate return array
	my @returnValues;
	push @returnValues, "$length";
	push @returnValues, "$capitalLetters";
	push @returnValues, "$lowerLetters";
	push @returnValues, "$numbers";
	push @returnValues, "$specialCharacters";
	push @returnValues, "$brackets";
	push @returnValues, "$space";
	#Help menu, if the help flag is seen the program displays this then exists.
	if ($help == 1)
	{
		print "Usage pwgen.pl [switches]\n";
		print "\t-l[number] - The number of characters in the password.\n";
		print "\t-c - Use Upper Case Letters in Password Generation.\n";
                print "\t-o - Use Lower Case Letters in Password Generation.\n";
		print "\t-n - User Numbers\n";
                print "\t-a - Use Special characters (!@#\$\%^&*-_=+\\|;:'\",./?) in Password Generation.\n";
                print "\t-b - Use Brackets in Password ()[]{}<>.\n";
                print "\t-s - Use the Space Character.\n";
                print "\t-h - Get this help Message\n";
		print "\n";
                print "\t--length[number] - The number of characters in the password.\n";
                print "\t--capital - Use Upper Case Letters in Password Generation.\n";
                print "\t--lower - Use Lower Case Letters in Password Generation.\n";
		print "\t--numbers - Use Numbers\n";
                print "\t--characters - Use Special characters (!@#\$\%^&*-_=+\\|;:'\",./?) in Password Generation.\n";
                print "\t--brackets - Use Brackets in Password ()[]{}<>.\n";
                print "\t--space - Use the Space Character.o\n";
                print "\t--help - Get this help Message\n";
		exit;
	}
	return @returnValues;
}

sub charSelect
{
	#Take in Characters
	my @charSelectArray = @_;
	#Get the number of array elements
	my $totalChars = @charSelectArray;
	#Get a random character from the array
	my $passChar = $charSelectArray[rand $totalChars];
	#return the character
	return $passChar;
}

sub passgen
{
	#Setup flag values.
	my @inputVars = @_;
		#inputVars[0] = Password Length
		#InputVars[1] = Uppercase Letter Flag
		#InputVars[2] = Lowercase Letter Flag 
		#InputVars[3] = Number Flag
		#InputVars[4] = Special Character Flag
		#InputVars[5] = Bracket Flag
		#InputVars[6] = Space Flag
	my @password;
	my $passChar = '';
	my $passwordReturn = '';
	#If no flags are set, then these are the default values to use.  
	if ($inputVars[1] == 0 && $inputVars[2] == 0 && $inputVars[3] == 0 && $inputVars[4] == 0 && $inputVars[5] == 0 && $inputVars[6] == 0)
	{
		$inputVars[1] = 1;
		$inputVars[2] = 1;
		$inputVars[3] = 1;
		$inputVars[4] = 1;
		$inputVars[5] = 1;
	}
	#For each character in the array do the following:
	while (scalar @password  + 1 <= $inputVars[0])
	{
		#Select which character type to use for the character.  Uppercase, Lowercase, Numbers, Special Characters, Brackets, and Space (Randomize a number between 1 and 6.
		my $charTypeSelect = int(rand(6)) + 1;
		#Now check the result
		given ($charTypeSelect)
		{
			when(1) 
			{
				#If Uppercase letters are deselected, end the iteration.
				if ($inputVars[1] == 0) 
				{
					break;
				} 
				#Create an array containing the capital letters
				my @upperLetters=('A'..'Z'); 
				$passChar = charSelect(@upperLetters);
				break; 
			}
			when(2) 
			{
				#If Lowercase letters are deselected, end the iteration
				if ($inputVars[2] == 0)
				{
					break;
				} 
				#Create an array with the lowercase letters
				my @lowerLetters=('a'..'z'); 
				$passChar = charSelect(@lowerLetters);
				break; 
			}
			when(3) 
			{
				#If numbers are deselected, end the iteration
				if ($inputVars[3] == 0)
				{
					break;
				} 
				#Create an array with the numbers 0-9 in it
				my @numbers=('0'..'9');
				$passChar = charSelect(@numbers); 
				break; 
			}
			when(4) 
			{
				#If Special characters are deselected end the iteration 
				if ($inputVars[4] == 0)
				{
					break;
				} 
				#Create an array with the special characters
				my @specialChars=('!','@','#','$','%','^','&','*','-','_','=','+','\\','|',';',':','"','\'',',','.','/','?','`','~'); 
				$passChar = charSelect(@specialChars);
				break; 
			}
			when(5) 
			{
				#If Bracket characters are deselected end the iteration
				if ($inputVars[5] == 0)
				{
					break;
				} 
				#Create an array with the "Bracket Characters" In it
				my @brackets=('[',']','{','}','(',')','<','>');
				$passChar = charSelect(@brackets); 
				break; 
			}
			when(6) 
			{
				#If Space is deselected, end the iteration
				if ($inputVars[6] == 0)
				{
					break;
				} 
				#Set the character to the space character
				$passChar = " "; 
				break; 
			}
		}
		push (@password, "$passChar");
	}
	$passwordReturn = join('',@password);
	return $passwordReturn;
}

sub main
{
	my $password = passgen(flagsIn());
	print "$password";
}

main();
