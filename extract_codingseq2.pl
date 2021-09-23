open(E,$ARGV[0]);
while($line=<E>){
        chomp($line);
        $a1{$line}=1;
}
close(E);

open(F,$ARGV[1]);
while($_=<F>){
        chomp($_);
        @a=split(/\t/,$_);
        @b=split(/\"/,$a[8]);
        if(exists($a1{$b[1]})){
                print"$_\n";
        }
}
close(F);
