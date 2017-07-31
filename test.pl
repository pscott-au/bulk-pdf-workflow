#!/usr/bin/perl

use strict;
use warnings;
use GD;
use PDF::API2;
use MIME::Base64;

use Data::Dumper;
 use Time::HiRes qw(usleep ualarm gettimeofday tv_interval);

=pod

  this is an exploratory test.
  hacked to include roughly structured workflow
  is simplified:
    - single page pdf only
    - 

=cut 

  #my $t0 = [gettimeofday];
  # do bunch of stuff here

 #sleep(5);
 #my $t1 = [gettimeofday];
  # do more stuff here
 # my $t0_t1 = tv_interval $t0, $t1;
#print $t0_t1;
#exit;

=pod
 Hard Coded proof of concept code
 to manage complete workflow of data load, transform and render 
 to PDF for print.

 AUTHOR: Peter Scott
 LAST MODIFIED: 30th July, 2017

=cut

my $handler_ref = \&handle_name;
my $job_setup = {
  pdf_template => 'PDF_Templates/CCP_STATEMENT_TEMPLATE.pdf',
  data => test_data(),
  callbacks => {
    name => {
        process => \&handle_name, #$handler_ref,
    }
  },
};

#my $data = test_data();


## Main process loop
my $stats = generate_pdfs_from_data( $job_setup );
print tv_interval  $stats->{start_hrt}, $stats->{finish_hrt};
print  " secs\n";
print Dumper $stats;



########### SUBS #########

sub generate_pdf
{
    my ( $row, $id, $transformers ) = @_;
    my $pdf = PDF::API2->open( $job_setup->{pdf_template} );


    return $pdf;
}
###########################

=pod

=head1 generate_pdfs_from_data()

=cut

sub generate_pdfs_from_data
{
    my ( $job ) = @_;
    my $data = $job->{data};
    my $stats = {
        start_hrt => [gettimeofday],
        finish_hrt => undef,
        count => 0,
    };
    
    
    foreach my $row ( @$data )
    { 
        $stats->{count}++;
        print qq{-- $row->{name} $stats->{count} \n};
        my $pdf = generate_pdf( $row, $stats->{count} );
        foreach my $field_name ( keys %$row )
        {
            if ( defined $job->{callbacks}{$field_name}{process} )
            {
                if ( defined $row->{$field_name} )
                {
                    $job->{callbacks}{$field_name}{process}->( $pdf, $row->{$field_name}  );
                }
            }            
        }
        $pdf->saveas("output/test-$stats->{count}.pdf");
    }
    $stats->{finish_hrt} = [gettimeofday];
    die('no records') unless ($stats->{count}>0);
    $stats->{average_secs_per_pdf} = (tv_interval  $stats->{start_hrt}, $stats->{finish_hrt} ) / $stats->{count};
    return $stats;  

}
###########################

=pod

=head1 pre_process_data()

  perform all validation tests, execute any field pre-processors

=cut

sub pre_process_data
{
    my ( $data,  ) = @_;
    foreach my $row ( @$data )
    {

    }

}
###########################


sub test_data 
{
   # my () = @_;
   my @fields = qw/name email amount account_ref address_1 address_2/;
   my $data_rows = [];

   for (my $i=0; $i<500; $i++)
   {
       my $row_data = {};
       foreach my $f (@fields ) { $row_data->{$f} = "$f$i";}
       push @$data_rows, $row_data;
   }
   return $data_rows;

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
###########################

#################################################################################
#################################################################################
#################################################################################

sub handle_name
{
    my ( $pdf, $val ) = @_;
    print "test handle_name with $val\n";
    #die('foo');
    my $page = $pdf->openpage(1);
    #my $font = $pdf->ttfont('fonts/OROSKO Free.ttf');
    my $font = $pdf->corefont('Helvetica-Bold');
    # Add some text to the page
    my $text = $page->text();
    $text->font($font, 12);
    $text->translate(50, 690);
    $text->text($val);
    $text->translate(50, 670);
    $text->text("$val line 2");

    $text->translate(50, 3);
    $text->text("$val line 3");

    #$text->translate(50, 830);
    #$text->text("$val line 4-3");

$text->translate(50, 835);
    $text->text("$val line 4-4");

}



