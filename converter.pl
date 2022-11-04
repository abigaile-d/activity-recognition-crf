
$inFile = "data.txt";
$outFile = ">dataV2.txt";

if(open(INFP, $inFile)) {
    if(open(OUTFP, $outFile)) {
        $sequenceName = " ";
        $line = <INFP>;
        
        while ($line ne ""){
            
            chomp($line);
            @featureArray = split(/,/, $line);
            @featureArray[7] =~ s/\ /-/g; # replace spaces with dash
            
            # Reassemble the array such that date and time are separated
            $tempLine = join(" ", @featureArray);
            @featureArray = split(/\s+/, $tempLine);
            
            # Preprocess other features except the first one
            for($index = 5; $index < 8; $index++) {
                if(substr($featureArray[$index], 0, 1) ne "-"){
                    $featureArray[$index] = substr($featureArray[$index], 0, 3);
                } else {
                    $featureArray[$index] = substr($featureArray[$index], 0, 4);
                }
            }
            
            # Put label +1 column so that we can add another feature
            $featureArray[9] = $featureArray[8];
            # Add hidden feature
            if($featureArray[8] eq "walking") {
                $featureArray[8] = "up";
            } elsif($featureArray[8] eq "falling") {
                $featureArray[8] = "transition-down";
            } elsif($featureArray[8] eq "lying-down") {
                $featureArray[8] = "transition-down";
            } elsif($featureArray[8] eq "lying") {
                $featureArray[8] = "down";
            } elsif($featureArray[8] eq "sitting-down") {
                $featureArray[8] = "transition-down";
            } elsif($featureArray[8] eq "sitting") {
                $featureArray[8] = "down";
            } elsif($featureArray[8] eq "standing-up-from-lying") {
                $featureArray[8] = "transition-up";
            } elsif($featureArray[8] eq "sitting-on-the-ground") {
                $featureArray[8] = "down";
            } elsif($featureArray[8] eq "standing-up-from-sitting") {
                $featureArray[8] = "transition-up";
            } elsif($featureArray[8] eq "standing-up-from-sitting-on-the-ground") {
                $featureArray[8] = "transition-up";
            } elsif($featureArray[8] eq "on-all-fours") {
                $featureArray[8] = "transition-down";
            }
            
            # If the sequence name is the same, append
            if($sequenceName eq $featureArray[0]) {
                $featureArray[0] = substr($featureArray[0], 0, 1);
                # Exclude the timestamp and date
                $newEntry = join(" ", $featureArray[1], @featureArray[5..9]);
                print OUTFP "$newEntry\n";
            } else { # otherwise, new sequence
                $sequenceName = $featureArray[0];
                $featureArray[0] = substr($featureArray[0], 0, 1);
                # Exclude the timestamp and date
                $newEntry = join(" ", $featureArray[1], @featureArray[5..9]);
                print OUTFP "\n$newEntry\n";
            }
            
            $line = <INFP>;
        }

        close(OUTFP);
    } else {
        die("Cannot open output file");
    }
    close(INFP);
} else {
    die("Cannot open input file");
}
