#Download the required modules and set the PERLLIB for https/JSON/LWP
# for ReadKey , you might want to run make, make install
use LWP::UserAgent;
use HTTP::Request;
use LWP::Protocol::https;
use HTTP::Cookies;
use JSON::PP;
use Data::Dumper;
use Term::ReadKey;


sub scanCookies {
    shift;
    my $key = shift;
    if ($key eq 'JSESSIONID') {
        $loggedIn = 1;
    }
}

sub login {
    my ($USERNAME,$PASSWORD) = @_;
    my $login = $baseUrl . '/rest/auth/latest/session';
    my $req = HTTP::Request->new('GET',$login);
    $req->header('Content-Type' => 'application/json');
    $req->authorization_basic($USERNAME, $PASSWORD);
    $lwp->request($req);
}

sub getIssue {
    my $issueID = shift;
    my $issue = $baseUrl . '/jira/rest/api/latest/issue/' . $issueID;
    my $response = $lwp->get($issue);
    my $json = $response->decoded_content;
    my $VAR1 = decode_json $json;
    # Uncomment to see all the information available.
    # Warning: you will get a ton of output.
    #print Dumper $VAR1;
    my $summary = "$VAR1->{'fields'}{'summary'}~";
    my $comments;
    for(my $i=0; $i < scalar(keys %{$VAR1->{'fields'}{'comment'}{'comments'}}); $i++) {
       $comments.="$VAR1->{'fields'}{'comment'}{'comments'}[$i]{'body'};;";
    }
    $comments =~ s/\n/\\n/g;
    print $issueID."~".$summary."~".$comments."\n";
}

sub getWatchers {
   # Warning: even if watchCount > 0, watchers array may be empty!
   my $issueID = shift;
   my $issue = $baseUrl . '/rest/api/latest/issue/' . $issueID . '/watchers';
   my $response = $lwp->get($issue);
   my $json = $response->decoded_content;
   my $VAR1 = decode_json $json;
   my @retval;
   my $idx;
   foreach $idx (0 .. $VAR1->{'watchCount'} - 1) {
      push @retval, $VAR1->{'watchers'}[$idx]{'name'};
   }
   return @retval;
}

sub logout {
    $lwp->cookie_jar->clear;
    $loggedIn = 0;
}

local $baseUrl = 'https://jira.xyzpay.com';
local $lwp = LWP::UserAgent->new(ssl_opts => { verify_hostname => 1 , SSL_ca_file => '/x/home/user/certificates/jira.cert' });
my $cookie_jar = HTTP::Cookies->new(file => 'cookies.txt', autosave => 1, ignore_discard => 1);
$lwp->cookie_jar($cookie_jar);

local $loggedIn = 0;

$cookie_jar->scan(\&scanCookies);
if (!$loggedIn) {
    # Get user credentials. Have to check whether we are on
    # Windows or Linux.
    $USERNAME = 'userId';
    $PASSWORD = 'password';
    login($USERNAME,$PASSWORD);
}

my $issue = '54503';
getIssue($issue);
