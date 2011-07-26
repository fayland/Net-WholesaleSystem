package Net::WholesaleSystem;

# ABSTRACT: VentraIP Wholesale SSL API

use warnings;
use strict;
use Carp qw/croak/;
use SOAP::Lite;
use vars qw/$errstr/;

sub new {
    my $class = shift;
    my $args = scalar @_ % 2 ? shift : { @_ };
    
    # validate
    $args->{resellerID} or croak 'resellerID is required';
    $args->{apiKey}     or croak 'apiKey is required';

    if ($args->{is_ote}) {
        $args->{url} ||= 'https://api-ote.wholesalesystem.com.au/?wsdl';
    } else {
        $args->{url} ||= 'https://api.wholesalesystem.com.au/?wsdl';
    }
    
    SOAP::Trace->import('all') if $args->{debug};
    # Init SOAP
    $SOAP::Constants::PREFIX_ENV = 'SOAP-ENV';
    my $soap = SOAP::Lite
        #->readable(1)
        ->ns('', 'ns1')
        ->ns('http://xml.apache.org/xml-soap', 'ns2')
        ->proxy($args->{url});
#    $soap->outputxml('true'); # XML
    $soap->on_action(sub { qq("#$_[0]") });
    $args->{soap} = $soap;
    
    bless $args, $class;
}

sub errstr { $errstr }

sub _check_soap {
    my ($som) = @_;
    
    if ($som->fault) {
        $errstr = $som->faultstring;
        return;
    }
    
    if ($som->result->{errorMessage}) {
        $errstr = $som->result->{errorMessage};
        return;
    }
    
    return 1;
}

sub balanceQuery {
    my ($self) = @_;
    
    my $soap = $self->{soap};
    my $method = SOAP::Data->name('balanceQuery')->prefix('ns1');
    
    # the XML elements order matters
    my $ele_resellerID = SOAP::Data->name('item')->type(ordered_hash => [ key => 'resellerID', value => $self->{resellerID} ]);
    my $ele_apiKey = SOAP::Data->name('item')->type(ordered_hash => [ key => 'apiKey', value => $self->{apiKey} ]);
    
    my $som = $soap->call($method,
        SOAP::Data->name( param0 => \SOAP::Data->value($ele_resellerID, $ele_apiKey) )->type('ns2:Map')
    );
    
    _check_soap($som) or return;
    
    return $som->result->{balance};
}



1;
__END__

=head1 SYNOPSIS

    use Net::WholesaleSystem;

    my $WholesaleSystem = Net::WholesaleSystem->new(
        resellerID => $resellerID,
        apiKey     => $apiKey
    );
    
    # get balance
    my $balance = $WholesaleSystem->balanceQuery or die $WholesaleSystem->errstr;
    print $balance;

=head2 DESCRIPTION

VentraIP Wholesale SSL API

=head3 new

    my $WholesaleSystem = Net::WholesaleSystem->new(
        resellerID => $resellerID,
        apiKey     => $apiKey
    );

=over 4

=item * C<resellerID> (required)

=item * C<apiKey> (required)

resellerID & apiKey, provided by VentraIP Wholesale

=item * C<is_ote>

if C<is_ote> is set to 1, we use https://api-ote.wholesalesystem.com.au/?wsdl instead of https://api.wholesalesystem.com.au/?wsdl

=item * C<debug>

enable SOAP::Trace->import('all')

=back

=head3 balanceQuery

    my $balance = $WholesaleSystem->balanceQuery or die $WholesaleSystem->errstr;
    
Account Balance Query allows you to obtain the account balance.


