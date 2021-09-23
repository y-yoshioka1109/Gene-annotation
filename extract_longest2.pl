open(E,$ARGV[0]);
while($line=<E>){
	chomp($line);
	$a1{$line}=1;
	@d=split(/\./,$line);
	$name=$d[0].".$d[1]";
	$a2{$name}=1;
}
close(E);

open(F,$ARGV[1]);
while($_=<F>){
	chomp;
	@a=split(/\t/,$_);
	@b=split(/;/,$a[8]);
	if($a[2] eq gene){
		@b[0]=~s/ID=//g;
		if(exists($a2{$b[0]})){
			print "$_\n";
		}
	}elsif ($a[2] eq CDS) {
		$b[0]=~s/ID=cds.//g;
		if(exists($a1{$b[0]})){
			print "$_\n";
		}
	}else{
		@b[0]=~s/ID=//g;
		@c=split(/\./,$b[0]);
		$tar=$c[0].".$c[1]".".$c[2]".".$c[3]";
		if(exists($a1{$tar})){
			print "$_\n";
		}	
	}
}
close(F);
