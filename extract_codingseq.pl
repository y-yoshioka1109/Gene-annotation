open(E,$ARGV[0]);
while($line=<E>){
	chomp($line);
	$a1{$line}=1;
	@b=split(/\./,$line);
	$name=$b[0];
	$b1{$name}=1;
}
close(E);

open(F,$ARGV[1]);
while($_=<F>){
	chomp;
	@a=split(/\t/,$_);
	@b=split(/Parent=/,$_);
	if($a[2] eq gene){
		print "$_\n";
	}elsif($a[2] eq transcript){
		if(exists($a1{$a[8]})){
		print "$_\n";
		}
	}else{
		@b=split(/\"/,$a[8]);
		if(exists($a1{$b[1]})){
			print"$_\n";
		}
		
	}
}
close(F);
