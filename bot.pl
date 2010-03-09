use strict;
use Net::IRC;

my $ts = localtime;
my $irc = new Net::IRC;
my $server = "irc.freenode.net";
my $port = "6667";
my $nick = "kazi-bot";
my $room = "#kazi";
my $room2 = "#botters";
my $nick2 = "kazibot";
print "[$ts] Connecting to IRC..\n";

my $conn = $irc->newconn(Server => $server,
             Port => $port,
             Nick => $nick,
             Ircname => $nick,
             Channel => $room,
             Username => $nick)
    or die "[$ts] Can't connect to IRC server.\n";
 
sub on_connect {
    my $self = shift;
    $conn->join($room);
    $conn->join($room2);
}
 
sub on_init {
    my ($self, $event) = @_;
    my (@args) = ($event->args);
    shift (@args);
    print "[$ts] @args\n";
}
 
sub on_public {
    my ($self, $event) = @_;
    my @to = $event->to;
    my ($nick, $mynick) = ($event->nick, $self->nick);
    my $host=$event->host;
    my ($arg) = ($event->args);
    print "[$ts][@to][$nick] $arg\n";
     if ($arg =~ /^!([^ ]+)(?: (.+))?/) {
        my $command = $1;
        my $remaining_parameters = $2;

          if ("about" eq $command) {
          $conn->privmsg(@to, $event->nick, ": Running Kynk 0.1 RC.");
          }
          if ("say" eq $command) {
          $conn->privmsg(@to, $remaining_parameters);
          }
          if ("nick" eq $command){ if($event->host eq "c-68-53-131-117.hsd1.tn.comcast.net"){ 
          $conn->nick($remaining_parameters);  } else {
          $conn->privmsg(@to, $event->nick,": You cannot access that command!");
          }
          }
          if ("commands" eq $command){ if($event->host eq "c-68-53-131-117.hsd1.tn.comcast.net"){ 
          $conn->privmsg(@to, $event->nick,": about, commands, join, nick, part, quit, say");  } else {
          $conn->privmsg(@to, $event->nick,": about, commands, say");
          }
          }
          if ("quit" eq $command){ if($event->host eq "c-68-53-131-117.hsd1.tn.comcast.net"){ 
          $conn->privmsg(@to, $event->nick,": Closing.."); $conn->quit("Requested."); exit();        } else {
          $conn->privmsg(@to, $event->nick,": You cannot access that command!");
          }
          }
          
          if ("part" eq $command){ if($event->host eq "c-68-53-131-117.hsd1.tn.comcast.net"){ 
          $conn->part($remaining_parameters); } else {
          $conn->privmsg(@to, $event->nick,": You cannot access that command!");
          }
          }

          if ("join" eq $command){ if($event->host eq "c-68-53-131-117.hsd1.tn.comcast.net"){ 
          $conn->join($remaining_parameters);  } else {
          $conn->privmsg(@to, $event->nick,": You cannot access that command!");
          }
          }
     }

}
 
 

 
sub on_msg {
    my ($self, $event) = @_;
    my ($nick) = $event->nick;
    my ($msg) = ($event->args);
    my $host=$event->host;
    print "[$ts][$nick] $msg\n";
}
 
sub on_nick_taken {
    my ($self) = shift;
    $self->nick($nick2);
}
sub on_join {
	my ($conn, $event) = @_;
        my @to = $event->to;
	my $nick = $event->{nick};
	print "[$ts][@to] $nick has joined.\n";
}
	
sub on_part {
	my ($conn, $event) = @_;
        my @to = $event->to;
	my $nick = $event->{nick};
	print "[$ts][@to] $nick has left.\n";
}

$conn->add_handler('public', \&on_public);
$conn->add_handler('msg', \&on_msg);
$conn->add_handler('join', \&on_join);
$conn->add_handler('part', \&on_part);
$conn->add_global_handler([ 251,252,253,254,302,255 ], \&on_init);
$conn->add_global_handler(376, \&on_connect);
$conn->add_global_handler(433, \&on_nick_taken);
$irc->start;
 
