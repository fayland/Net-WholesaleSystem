#!/usr/bin/perl

use strict;
use warnings;
use lib '../lib';
use Data::Dumper;
use Net::WholesaleSystem;

my $WholesaleSystem = Net::WholesaleSystem->new(
    resellerID => $ENV{resellerID},
    apiKey     => $ENV{apiKey},
    is_ote     => 1,
    debug      => 1,
);

=pod

my $balance = $WholesaleSystem->balanceQuery or die $WholesaleSystem->errstr;
print $balance;

=cut

my $csr = <<'CSR';
-----BEGIN CERTIFICATE-----
MIICxDCCAi0CBECcV/wwDQYJKoZIhvcNAQEEBQAwgagxCzAJBgNVBAYTAlVTMQ4wDAYDVQQIEwVU
ZXhhczEPMA0GA1UEBxMGQXVzdGluMSowKAYDVQQKEyFUaGUgVW5pdmVyc2l0eSBvZiBUZXhhcyBh
dCBBdXN0aW4xKDAmBgNVBAsTH0luZm9ybWF0aW9uIFRlY2hub2xvZ3kgU2VydmljZXMxIjAgBgNV
BAMTGXhtbGdhdGV3YXkuaXRzLnV0ZXhhcy5lZHUwHhcNMDQwNTA4MDM0NjA0WhcNMDQwODA2MDM0
NjA0WjCBqDELMAkGA1UEBhMCVVMxDjAMBgNVBAgTBVRleGFzMQ8wDQYDVQQHEwZBdXN0aW4xKjAo
BgNVBAoTIVRoZSBVbml2ZXJzaXR5IG9mIFRleGFzIGF0IEF1c3RpbjEoMCYGA1UECxMfSW5mb3Jt
YXRpb24gVGVjaG5vbG9neSBTZXJ2aWNlczEiMCAGA1UEAxMZeG1sZ2F0ZXdheS5pdHMudXRleGFz
LmVkdTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAsmc+6+NjLmanvh+FvBziYdBwTiz+d/DZ
Uy2jyvij6f8Xly6zkhHLSsuBzw08wPzr2K+F359bf9T3uiZMuao//FBGtDrTYpvQwkn4PFZwSeY2
Ynw4edxp1JEWT2zfOY+QJDfNgpsYQ9hrHDwqnpbMVVqjdBq5RgTKGhFBj9kxEq0CAwEAATANBgkq
hkiG9w0BAQQFAAOBgQCPYGXF6oRbnjti3CPtjfwORoO7ab1QzNS9Z2rLMuPnt6POlm1A3UPEwCS8
6flTlAqg19Sh47H7+Iq/LuzotKvUE5ugK52QRNMa4c0OSaO5UEM5EfVox1pT9tZV1Z3whYYMhThg
oC4y/On0NUVMN5xfF/GpSACga/bVjoNvd8HWEg==
-----END CERTIFICATE-----
CSR

if ( my $output = $WholesaleSystem->decodeCSR($csr) ) {
    print Dumper(\$output);

    my $cert = $WholesaleSystem->purchaseSSLCertificate(
        csr => $csr,
        productID => 55,
        firstName => 'Fayland',
        lastName  => 'Lam',
        emailAddress => 'fayland@gmail.com',
        address => 'TestAddr',
        city => 'RA',
        state => 'ZJ',
        postCode => '32520',
        country => 'China',
        phone => '+8612345678',
        fax => '+8612345678',
    ) or die $WholesaleSystem->errstr;
    print Dumper(\$cert);
} else {
    print $WholesaleSystem->errstr . "\n";
}

my $all_certs = $WholesaleSystem->listAllCerts or die $WholesaleSystem->errstr;
print Dumper(\$all_certs);

1;