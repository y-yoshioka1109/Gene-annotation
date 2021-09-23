open(F,$ARGV[0]);
while($line=<F>){
	chomp;
	@c=split(/\t/,$line);
	$d{$c[0]}=$c[1];
}
close(F);

open(G,$ARGV[1]);
while($_=<G>){
	chomp;
	@a=split(/\t/,$_);
	$a[0]=~s/sc000/s/g;
	if($a[2] eq gene){
		$gene=$d{$a[8]};
		$gene=~s/\n//g;
		print "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\t$gene\n";
#	}elsif($a[2] eq transcript){
	}else{
		@b=split(/\"/,$a[8]);
		print "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\t"."$b[0]"."\""."$gene.t1"."\"".$b[2]."\"".$gene."\";\n";
	}
}
close(G);
