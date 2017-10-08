#!/usr/bin/perl
# Variable Initialization
$log = "/home/pi/scripts/sysinfo.log";
$file = "/home/pi/scripts/datafile";
$image = "/home/pi/scripts/info.jpg";

# Prepartion
clearfile();

# Get IP Information
writefile("##### Local Network Information #####");
$data = `/bin/ls /sys/class/net`;
@inf = split('\n', $data);
for ($i = 0; $i < @inf; $i++) {
	if ($inf[$i] ne "lo") {
		$data = `/sbin/ifconfig $inf[$i] | /bin/grep "inet" | /usr/bin/tr -s ' '`;  
		$data =~ s/^\s+//;
		$data =~ s/inet addr://;
		$data =~ s/Bcast://;
		$data =~ s/Mask://;
		if ($data ne "") {
			@ip_data = split(' ', $data);	
			$ip = $ip_data[0];
			$bcast = $ip_data[1];
			$mask = $ip_data[2];	
			logfile("Interface: $inf[$i] IP: $ip Mask:$mask"); 
			writefile("Interface: $inf[$i] IP: $ip Mask: $mask");
		}
	}
}

# Get Neighbor IPs
writefile("\n##### Neighbor Network Information #####");
$data = `/bin/ip neighbor show | /bin/grep -v FAILED | /usr/bin/sort -n`;
@lines = split('\n', $data);
for ($i = 0; $i < @lines; $i++) {
	@neighbor = split(' ', $lines[$i]);
	logfile("Neighbor IP: $neighbor[0] MAC: $neighbor[4]");
	writefile("Neighbor IP: $neighbor[0] MAC: $neighbor[4]");
}

# Get CPU Info
writefile("\n##### System CPU Information #####");
$data = `/usr/bin/mpstat | /bin/grep "all" | /usr/bin/tr -s ' '`;
@cpu = split(' ', $data);
$usr = $cpu[3];
$sys = $cpu[5];
logfile("User: $usr% System: $sys%");
writefile("User: $usr% System: $sys%");

# Get Disk Info 
writefile("\n##### System Disk Information #####");
$data = `/bin/df -h | /bin/grep "/dev/root" | /usr/bin/tr -s ' '`;
@disk = split(' ', $data);
$total = $disk[1];
$used = $disk[2];
$avail = $disk[3];
logfile("Total: $total Used: $used Available: $avail");
writefile("Total: $total Used: $used Available: $avail");

# Get Memory Info
writefile("\n##### System Memory Information #####");
$data = `/usr/bin/free -h | /bin/grep "Mem" | /usr/bin/tr -s ' '`;
@mem = split(' ', $data);
$total = $mem[1];
$used = $mem[2];
$free = $mem[3];
logfile("Total: $total Used: $used Free: $free");
writefile("Total: $total Used: $used Free: $free");

# Show Output
convert();
output();

sub convert {
	logfile("Converting file to picture");
	#`/bin/cat $file | /usr/bin/convert -background black -fill white label:\@- -pointsize 12 -resize 320x240 $image`; 
	`/bin/cat $file | /usr/bin/convert -background black -fill white label:\@- $image`; 
}

sub output {
	logfile("Sending to framebuffer");
	`/usr/bin/sudo /usr/bin/fbi -d /dev/fb1 -P -T 1 -noverbose $image > /dev/null 2>&1`;
}
 
sub clearfile {
	open(FILE, "> $file");
	close(FILE);
}

sub writefile {
	$message = $_[0];
	open(FILE, ">> $file");
	print FILE "$message\n";
	close(FILE);
}

sub logfile {
	$message = $_[0];
	print "$message\n";

	$timestr = get_time();
	open(FILE, ">> $log");
	print FILE "[$timestr] $message\n";
	close(FILE);
}

sub get_time {
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
        $year += 1900; $mon++; $mon = sprintf("%02d", $mon); $mday = sprintf("%02d", $mday);
        $sec = sprintf("%02d", $sec); $min = sprintf("%02d", $min); $hour = sprintf("%02d", $hour);
        $log_datestring = $year . '-' . $mon . '-' . $mday;
        $log_timestring = $log_datestring . ' ' . $hour . ':' . $min . ':' . $sec;
	return $log_timestring;
}
