
$inFile = "dataV2.txt";
$trainFile = ">trainSet.txt";
$testFile = ">testSet.txt";
$isTrain = 1;

if(open(INFP, $inFile)) {
    if(open(TRAINFP, $trainFile) && open(TESTFP, $testFile)) {

        $line = <INFP>;
        
        while ($line ne ""){
            
            chomp($line);
            
            if($line eq "" && $isTrain == 1) {
                $isTrain = 0;
            } elsif($line eq "" && $isTrain == 0) {
                $isTrain = 1;
            }
            
            # If the flag is 1, then the data will be for training set
            if($isTrain == 0) {
                print TRAINFP "$line\n";
            } else { # test set otherwise
                print TESTFP "$line\n";
            }
            
            $line = <INFP>;
        }

        close(TRAINFP);
        close(TESTFP);
    } else {
        die("Cannot open output file");
    }
    close(INFP);
} else {
    die("Cannot open input file");
}
