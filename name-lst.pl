
while(<>){
	chomp;
	@c=split(/\./,$_);
	@a=split(/\t/,$_);
	$id = $c[0];
	$sco = $a[1]; ## here for seq length
	if($id eq $pid){
		$b{$sco} = $_;
	}
	elsif($id ne $pid){
		if (length ($pid)>1){
			my @keys_sorted = sort  { $b <=> $a } keys %b; #sort
			$top_id = shift @keys_sorted; # just get longest one 
			print "$b{$top_id}\n";
			%b=();
		}
		$b{$sco} = $_;
	}
	$pid=$id;
}

if (length ($pid)>1){
	my @keys_sorted = sort  { $b <=> $a } keys %b; #sort
	$top_id = shift @keys_sorted; # just get longest one 
	print "$b{$top_id}\n";
	%b=();
}
