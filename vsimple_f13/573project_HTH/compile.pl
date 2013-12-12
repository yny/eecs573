my $path = @ARGV[0];
my $line;
my $comment = 0;
my $row = 1;

my $setrow = 0;
my $setpwd = 0;
my $setnum = 0;

my $loginrow = 0;
my $loginpwd = 0;
my $loginnum = 0;

my $logoutrow = 0;
my $insert = 0;

open INPUT_FILE, "<", $path or die $!;
open OUTPUT_FILE, ">", "temp.s" or die $!;

while ( $line = <INPUT_FILE>)
{
	@word = split("\t", $line); 
	if (@word[1] =~ m/comment/) 
	{	
		$comment = 1;
	}
	if (@word[0] =~ m/comment/) 
	{	
		$comment = 0;
		next;
	}
	if ($comment == 1)
	{
		next;
	}
	else
	{
		if (@word[1] =~ m/setpwd/)
		{
			$setrow = $row;
			$setpwd = @word[2];
			$row ++;
			next;
		}
		if (@word[1] =~ m/login/)
		{
			$loginrow = $row;
			$loginpwd = @word[2];
			$row ++;
			next;	
		}
		if (@word[1] =~ m/logout/)
		{
			$logoutrow = $row;
			$row ++;	
			next;
		}
		$row ++;
	}
	print OUTPUT_FILE $line;	
}

close INPUT_FILE or die $!;			
close OUTPUT_FILE or die $!;		

system("./vs-asm temp.s > program2.mem");

$setnum = substr ($setpwd, 2, 5);
$loginnum = substr ($loginpwd, 2, 5);

open INPUT_FILE, "<", "program2.mem" or die $!;
open OUTPUT_FILE, ">", "program.mem" or die $!;

while ( chomp($line = <INPUT_FILE>))
{
	push (@inst, substr ($line, 0, 8), substr ($line, 8, 8));
}

print	(@inst + ($setrow != 0) + ($loginrow != 0) + ($logoutrow != 0)), "\n";
print $setrow, "\n";
print $loginrow, "\n";

for ( $i = 1; $i <= @inst + ($setrow != 0) + ($loginrow != 0) + ($logoutrow != 0); $i ++ )
{
	if ( $i == $setrow ) 
	{
		push (@final, ("7C0".$setnum));
		$insert ++;
	}
	elsif ( $i == $loginrow ) 
	{
		push (@final, ("640".$loginnum));
		$insert ++;
	}
	elsif ( $i == $logoutrow ) 
	{
		push (@final, "6C000000");
		$insert ++;
	}
	else
	{
		push (@final, @inst[$i-1-$insert]);
	}
}

for ( $i = 0; $i < @final; $i ++ )
{
	if ($i % 2)
	{
		print OUTPUT_FILE @final[$i], "\n";
	}
	else
	{
		print OUTPUT_FILE @final[$i];
	}
}

system("rm -f program2.mem");
system("rm -f temp.s");
close INPUT_FILE or die $!;			
close OUTPUT_FILE or die $!;





