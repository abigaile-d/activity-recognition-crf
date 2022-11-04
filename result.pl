$inFile = "MPtest.log";
$correct = 0;
$incorrect = 0;

if(open(INFP, $inFile)) {

    $line = <INFP>;
    
    while ($line ne ""){
        
        chomp($line);
            
        @featureArray = split(/\s+/, $line);
        $size = @featureArray;
        if($size == 7) {
            $string1 = $featureArray[5];
            $string2 = $featureArray[6];
            
            if($string1 eq $string2) {
                $correct++;
            } else {
                $incorrect++;
            }
        }
        
        $line = <INFP>;
    }
    
    print "Number of correct: $correct\n";
    print "Number of incorrect: $incorrect\n";
    
    $total = $correct + $incorrect;
    $correct = ($correct/$total)*100;
    $incorrect = ($incorrect/$total)*100;
    print "Correct %: $correct\n";
    print "Incorrect%: $incorrect\n";

    close(INFP);
} else {
    die("Cannot open input file");
}
