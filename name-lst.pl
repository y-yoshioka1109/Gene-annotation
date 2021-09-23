$c=0;
$prefix=meff;
while($_=<>){
	chomp;
	@a=split(/\t/,$_);
	$a[0]=~s/sc000/s/g;
	if($a[2] eq gene){
		$c++;
		if($c<10){
			print "$a[8]\t${prefix}_$a[0].g000$c\n";
		}elsif($c<100){
			print "$a[8]\t${prefix}_$a[0].g00$c\n";
		}elsif($c<1000){
			print "$a[8]\t${prefix}_$a[0].g0$c\n";
		}elsif($c<10000){
			print "$a[8]\t${prefix}_$a[0].g$c\n";
		}
	}
}
