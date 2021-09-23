open(E,$ARGV[0]);
while($line=<E>){
  chomp($line);
  $line=~s/gene/g/g;
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
        if($a[2] eq transcript){
                if(exists($a1{$a[8]})){
                        $_=~s/g/gene/g;
                        print "$_\n";
                }
        }elsif($a[2] eq gene){
                $test="$a[8].t1";
                if(exists($a1{$test})){
                        $a[8]=~s/g/gene/g;
                        print "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\t$a[8]\n";
                }
        }else{
                @b=split(/\"/,$a[8]);
                if(exists($a1{$b[1]})){
                        $_=~s/g/gene/g;
                        print"$_\n";
                }
                
        }
}
close(F);
