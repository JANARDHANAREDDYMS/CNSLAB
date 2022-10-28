set ns [new Simulator]

set nt [open lab1.tr w]
$ns trace-all $nt
set nf [open lab1.nam w]
$ns namtrace-all $nf
$ns color 1 blue
$ns color 2 black
$ns color 3 red
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
$n0 label "source/udp0"
$n1 label "source/udp1"
$n2 label "Router"
$n3 label "Destination/nul"
$ns duplex-link $n0 $n2 100Mb 300ms DropTail
$ns duplex-link $n1 $n2 100Mb 300ms DropTail
$ns duplex-link $n2 $n3 200Kb 300ms DropTail 
$ns queue-limit $n0 $n2 5
$ns queue-limit $n1 $n2 5
$ns queue-limit $n2 $n3 5

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set null3 [new Agent/Null]
$ns attach-agent $n0 $null3
set null3 [new Agent/Null]
$ns attach-agent $n3 $null3

set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1

$udp0 set class_ 1
$udp0 set class_ 2

$ns connect $udp0 $null3
$ns connect $udp1 $null3

$cbr1 set packetSize_ 500Mb
$cbr1 set interval_ 0.005


#$ns duplex-link-op $Client1 $Router1 queuePos 0.1
#$ns duplex-link-op $Router1 $EndServer1 queuePos 0.5
proc finish {} {
	global ns nf nt
	$ns flush-trace
	exec nam lab1.nam &
	close $nf
	close $nt
	exit 0
}

$ns at 0.1 "$cbr0 start"
$ns at 0.1 "$cbr1 start"
$ns at 6.0 "finish"
$ns run



