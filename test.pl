#!/usr/bin/perl

use strict;
use warnings;
use GD;
use PDF::API2;
use MIME::Base64;

=pod
 Hard Coded proof of concept code
 to manage complete workflow of data load, transform and render 
 to PDF for print.

 AUTHOR: Peter Scott
 LAST MODIFIED: 23rd July, 2017

=cut

my $job_setup = {
  pdf_template => 'PDF_Templates/CCP_STATEMENT_TEMPLATE.pdf',
};
my $data = test_data();

my $pdf = PDF::API2->open( $job_setup->{pdf_template} );
my $page = $pdf->openpage(1);

my $font = $pdf->ttfont('fonts/OROSKO Free.ttf');


# Add some text to the page
my $text = $page->text();
$text->font($font, 20);
$text->translate(200, 700);
$text->text('Hello World!');

$pdf->saveas('output/test.pdf');

sub test_data 
{
   # my () = @_;
    return [
        {
            name => '',
            email => '',
            amount => '',
            account_ref => '',
            address1 => '',
            address2 => '',
        }

    ];
}
