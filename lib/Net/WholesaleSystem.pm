package Net::WholesaleSystem;

# ABSTRACT: VentraIP Wholesale SSL API

use warnings;
use strict;
use Carp qw/croak/;
use SOAP::Lite;

sub new {
    my $class = shift;
    my $args = scalar @_ % 2 ? shift : { @_ };
    
    # validate
    $args->{ResellerID} or croak 'ResellerID is required';
    $args->{apiKey}     or croak 'apiKey is required';

    if ($args->{is_ote}) {
        $args->{url} ||= 'https://api-ote.wholesalesystem.com.au/?wsdl';
    } else {
        $args->{url} ||= 'https://api.wholesalesystem.com.au/?wsdl';
    }
    
    SOAP::Trace->import('all') if $args->{debug};
    
    bless $args, $class;
}

1;
__END__

=head1 SYNOPSIS

    use Net::WholesaleSystem;

    my $WholesaleSystem = Net::WholesaleSystem->new(
        ResellerID => $ResellerID,
        apiKey     => $apiKey
    );
    
    

=head2 DESCRIPTION

VentraIP Wholesale SSL API

=head3 new

    my $WholesaleSystem = Net::WholesaleSystem->new(
        ResellerID => $ResellerID,
        apiKey     => $apiKey
    );

=over 4

=item * C<ResellerID> (required)

=item * C<apiKey> (required)

ResellerID & apiKey, provided by VentraIP Wholesale

=item * C<is_ote>

if C<is_ote> is set to 1, we use https://api-ote.wholesalesystem.com.au/?wsdl instead of https://api.wholesalesystem.com.au/?wsdl

=item * C<debug>

enable SOAP::Trace->import('all')

=back

=head3 
