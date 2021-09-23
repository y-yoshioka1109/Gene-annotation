while($_=<>){
	chomp;
#	$_=~s/MSTRG./g/g;
	@a=split(/\t/,$_);
	if($a[1] eq transdecoder){
		if($a[2] eq exon){
			if($c==0){
				@b=split(/"/,$a[8]);
				$pre=substr($b[1],0,-3);
				@c=split(/\./,$pre);
				$pro="$c[0]."."p"."$c[1]";
				print "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\t"."$b[0]"."\"$pro\""."$b[2]"."\""."$b[3]"."\";\n";
				$c++;
				$start=$a[4]+1;
			}elsif($c>=1){
				$end=$a[3]-1;
				@b=split(/"/,$a[8]);
				$pre=substr($b[1],0,-3);
				@c=split(/\./,$pre);
				$pro="$c[0]."."p"."$c[1]";
				print "$a[0]\t$a[1]\tintron\t$start\t$end\t$a[5]\t$a[6]\t$a[7]\t"."$b[0]"."\"$pro\""."$b[2]"."\""."$b[3]"."\";\n";
				print "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\t"."$b[0]"."\"$pro\""."$b[2]"."\""."$b[3]"."\";\n";
				$start=$a[4]+1;
			}
		}elsif($a[2] eq gene){
			$c=0;
			print"$_\n";
		}elsif($a[2] eq transcript){
			@b=split(/"/,$a[8]);
			$pre=substr($b[1],0,-3);
			@c=split(/\./,$pre);
			$pro="$c[0]."."p"."$c[1]";
			print "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\t"."$b[0]"."\"$pro\""."$b[2]"."\""."$b[3]"."\";\n";
		}else{
			@b=split(/"/,$a[8]);
			$pre=substr($b[1],0,-3);
			@c=split(/\./,$pre);
			$pro="$c[0]."."p"."$c[1]";
			print "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\t"."$b[0]"."\"$pro\""."$b[2]"."\""."$b[3]"."\";\n";
		}
	}elsif($a[1] eq AUGUSTUS){
		if($a[2] eq transcript){
			@c=split(/\./,$a[8]);
#print "$_\n";
			print "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\t"."transcript_id "."\""."$a[8]"."\"; "."gene_id "."\""."$c[0]"."\"".";\n";
		}else{
			print"$_\n";
		}
	}
}

#transcript_id "g1.t1"; gene_id "g1";
