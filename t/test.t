#! /usr/bin/perl 

use Date::Holidays::AU qw( is_holiday holidays );
use Test::More(tests => 158 );
use strict;
use warnings;

# VIC https://www.business.vic.gov.au/victorian-public-holidays-and-daylight-saving
# NT http://www.nt.gov.au/ocpe/public_holidays.shtml
# WA https://www.commerce.wa.gov.au/labour-relations/public-holidays-western-australia
# QLD http://www.wageline.qld.gov.au/publicholidays/list_pubhols.html
# NSW https://www.nsw.gov.au/about-new-south-wales/public-holidays/
# SA http://www.eric.sa.gov.au/show_page.jsp?id=2483
# ACT http://www.workcover.act.gov.au/labourreg/publicholidays.html
# TAS http://www.wst.tas.gov.au/attach/stathol2004.pdf

eval { holidays(); };
ok($@ eq '', "Year and State defaults are provided");
eval { holidays( 'year' => undef); };
ok($@ eq '', "Undefined Year resorts to default:$@");
eval { holidays( 'year' => 'd144'); };
ok($@ ne '', "Year must be be numeric");
eval { holidays( 'year' => '14444'); };
ok($@ ne '', "Year must be numeric");
eval { holidays( 'year' => 2004, 'state' => 'V1C' ); };
ok($@ ne '', "State must exist");
ok(holidays( 'year' => 2004, 'state' => undef ));
ok(holidays( 'year' => 2004 ));

my ($holidays);
eval { $holidays = holidays( 'year' => 2004, 'state' => 'VIC' ); };
ok($@ eq '', "Holidays retrieved");
ok(((ref $holidays) && ((ref $holidays) eq 'HASH')), "holidays returns a hashref");
ok(((exists $holidays->{1225}) && (defined $holidays->{1225})), "Found Christmas");
ok($holidays->{1225} =~ /\w+/, "Christmas has a text representation (" . $holidays->{1225} . ")");
ok(is_holiday(2005, 1, 3, 'VIC'), "Extra New Years Day 2005");
ok(is_holiday(2005, 1, 1, 'VIC'), "New Years Day 2005");
ok(is_holiday(2005, 1, 1), "New Years Day 2005 (default state)");
ok(is_holiday(2004, 1, 7, 'TAS', { 'holidays' => ['Devonport Cup']}), "Devonport Cup 2004");
ok(is_holiday(2006, 1, 11, 'TAS', { 'holidays' => ['Devonport Cup'], nonsense_hash => {}}), "Devonport Cup 2006");
ok(is_holiday(2006, 1, 11, 'TAS', { 'holidays' => ['Devonport Cup']}), "Devonport Cup 2006");
eval {
	is_holiday(2019, 1, 28, 'TAS', { 'holidays' => 'WTF' });
};
ok($@ =~ /^Holidays parameter must be a reference to an array/, "Exception is thrown when the holidays parameter is not a reference");
eval {
	is_holiday(2019, 1, 28, 'TAS', { 'holidays' => {} });
};
ok($@ =~ /^Holidays parameter must be a reference to an array/, "Exception is thrown when the holidays parameter is not a reference to an array");
ok(not(is_holiday(2004, 1, 7, 'TAS', { 'holidays' => ['Recreation Day']})), "Not Devonport Cup 2004");
ok(is_holiday(2005, 1, 26, 'VIC'), "Australia Day 2005");
ok(is_holiday(2019, 1, 28, 'VIC'), "Australia Day 2019");
ok(is_holiday(2004, 2, 9, 'TAS', { 'holidays' => [ 'Hobart Show','Hobart Regatta' ]}), "Hobart Regatta 2004");
ok(not(is_holiday(2004, 2, 9, 'TAS', { 'holidays' => [ 'Hobart Show' ]})), "Not Hobart Regatta 2004");
ok(is_holiday(1900, 2, 28, 'TAS', { 'holidays' => [ 'Launceston Cup' ]}), "Launceston Cup 1900");
ok(is_holiday(2000, 2, 23, 'TAS', { 'holidays' => [ 'Launceston Cup' ]}), "Launceston Cup 2000");
ok(is_holiday(2004, 2, 25, 'TAS', { 'holidays' => [ 'Launceston Cup' ]}), "Launceston Cup 2004");
ok(is_holiday(2019, 2, 27, 'TAS', { 'holidays' => [ 'Launceston Cup' ]}), "Launceston Cup 2019");
ok(not(is_holiday(2004, 2, 25, 'TAS', { 'holidays' => [ 'Devonport Cup' ]})), "Not Launceston Cup 2004");
ok(is_holiday(2004, 3, 2, 'TAS', { 'holidays' => [ 'King Island Show' ]}), "King Island Show 2004");
ok(not(is_holiday(2004, 3, 2, 'TAS', { 'holidays' => [ 'Devonport Cup' ]})), "Not King Island Show 2004");
ok(is_holiday(2004, 3, 8, 'TAS'), "Eight Hours Day 2004");
ok(is_holiday(2005, 3, 7, 'WA'), "WA Labour Day 2005");
ok(is_holiday(2004, 3, 15, 'ACT'), "Canberra Day 2004");
ok(is_holiday(2004, 3, 15, 'ACT'), "Canberra Day 2004");
ok(is_holiday(2005, 3, 21, 'ACT'), "Canberra Day 2004");
ok(not(is_holiday(2005, 3, 8, 'WA')), "Not WA Labour Day 2005");
ok(is_holiday(2004, 4, 9, 'VIC'), "Good Friday 2004");
ok(is_holiday(2004, 4, 10, 'WA'), "Easter Saturday 2004");
ok(is_holiday(2004, 4, 11, 'NT'), "Easter Sunday 2004");
ok(is_holiday(2005, 3, 28, 'VIC'), "Easter Monday 2005");
ok(not(is_holiday(2005, 3, 29, 'VIC')), "No Easter Tuesday in VIC");
ok(is_holiday(2005, 3, 29, 'TAS'), "Easter Tuesday 2005 in TAS");
ok(!is_holiday(2005, 3, 29, 'VIC'), "Easter Tuesday 2005 does not exist for VIC");
ok(is_holiday(1997, 3, 30, 'TAS'), "Easter Sunday 1997");
ok(is_holiday(2051, 4, 2, 'TAS'), "Easter Sunday 2051");
ok(is_holiday(2024, 3, 31, 'TAS'), "Easter Sunday 2024");
ok(is_holiday(2005, 3, 14, 'VIC'), "Victorian Labour Day 2005");
ok(is_holiday(2006, 3, 13, 'SA'), "Adelaide Cup Day 2006");
ok(not(is_holiday(2005, 3, 14, 'SA')), "No Adelaide Cup Day in 2005");
ok(not(is_holiday(2005, 3, 14, 'NSW')), "Not NSW Labour Day 2005");
ok(is_holiday(2004, 4, 25, 'VIC'), "ANZAC Day 2004");
ok(is_holiday(2004, 4, 25, 'WA'), "ANZAC Day 2004");
ok(not(is_holiday(2004, 4, 26, 'VIC')), "No extra holiday for ANZAC Day 2004 in VIC");
ok(not(is_holiday(2004, 4, 26, 'TAS')), "No extra holiday for ANZAC Day 2004 in TAS");
ok(is_holiday(2004, 4, 26, 'WA'), "Extra holiday for ANZAC Day 2004 everywhere else");
ok(is_holiday(2005, 5, 16, 'SA'), "Volunteers Day 2005");
ok(is_holiday(2003, 5, 5, 'NT'), "May Day 2003");
ok(is_holiday(2005, 5, 2, 'NT'), "May Day 2005");
ok(not(is_holiday(2004, 5, 7, 'TAS')), "Not Agfest 2003");
ok(is_holiday(2004, 5, 7, 'TAS', { 'holidays' => [ 'Agfest' ]}), "Agfest 2004");
ok(not(is_holiday(2004, 5, 7, 'TAS', { 'holidays' => [ 'Devonport Cup' ]})), "Not Agfest 2004");
ok(not(is_holiday(2004, 5, 7, 'TAS')), "Not Agfest anywhere else in 2004");
ok(not(is_holiday(2005, 5, 15, 'SA')), "No Volunteers Day in 2006");
ok(is_holiday(2005, 6, 6, 'WA'), "Foundation Day 2005");
ok(is_holiday(2004, 6, 14, 'TAS'), "Queens Birthday 2004");
ok(is_holiday(2005, 6, 13, 'VIC'), "Queens Birthday 2005");
ok(is_holiday(2005, 6, 13, 'ACT'), "Queens Birthday 2005");
ok(is_holiday(2005, 6, 13, 'NT'), "Queens Birthday 2005");
ok(is_holiday(2007, 6, 11, 'QLD'), "Queens Birthday 2007");
ok(is_holiday(2006, 6, 12, 'NSW'), "Queens Birthday 2007");
ok(is_holiday(2006, 6, 12, 'SA'), "Queens Birthday 2007");
ok(not(is_holiday(2006, 6, 12, 'WA')), "Not WA Queens Birthday 2007");
ok(not(is_holiday(2005, 7, 1, 'NT')), "Not Alice Springs Show Day 2005");
ok(is_holiday(2005, 7, 1, 'NT', { 'region' => 'Alice Springs' }), "Alice Springs Show Day 2005");
ok(is_holiday(2005, 7, 8, 'NT', { 'region' => 'Tennant Creek' }), "Tennant Creek Show Day 2005");
ok(is_holiday(2005, 7, 15, 'NT', { 'region' => 'Katherine' }), "Katherine Show Day 2005");
ok(is_holiday(2005, 7, 22, 'NT', { 'region' => 'Darwin' }), "Darwin Show Day 2005");
ok(is_holiday(2005, 7, 22, 'NT', { 'region' => undef }), "Darwin is the default region");
eval {
	is_holiday(2005, 7, 22, 'NT', { 'region' => 'mispelingg' });
};
ok($@ =~ /^Unknown region/, "NT unknown region generates exception");
ok(is_holiday(2005, 7, 22, 'NT'), "Darwin Show Day 2005 (default)");
ok(not(is_holiday(2005, 7, 15, 'NT')), "Not Katherine Show Day 2005");
ok(not(is_holiday(2005, 8, 1, 'NSW')), "No NSW Bank Holiday 2005");
ok(is_holiday(2017, 8, 7, 'NSW', { 'include_bank_holiday' => 1 }), "NSW Bank Holiday 2017");
ok(is_holiday(2005, 8, 1, 'NSW', { 'include_bank_holiday' => 1 }), "NSW Bank Holiday 2005");
ok(not(is_holiday(2005, 8, 1, 'ACT')), "No ACT Bank Holiday 2005");
ok(is_holiday(2005, 8, 1, 'ACT', { 'include_bank_holiday' => 1 }), "ACT Bank Holiday 2005");
ok(not(is_holiday(2005, 8, 1, 'ACT', { 'include_bank_holiday' => 0 })), "No ACT Bank Holiday 2005");
ok(is_holiday(2005, 8, 1, 'NSW', { 'include_bank_holiday' => 1 }), "NSW Bank Holiday 2005");
ok(not(is_holiday(2005, 8, 1, 'NSW', { 'include_bank_holiday' => 0 })), "No NSW Bank Holiday 2005");
ok(is_holiday(2005, 8, 1, 'NT'), "Picnic Day 2005");
ok(not(is_holiday(2005, 8, 2, 'NT')), "Not Picnic Day 2005");
ok(is_holiday(2004, 8, 11, 'QLD'), "Queensland Show 2004");
ok(not(is_holiday(2005, 8, 17, 'QLD', { 'no_show_day' => 1 })), "No Queensland Show 2005");
ok(is_holiday(2005, 8, 17, 'QLD', { 'no_show_day' => 0 }), "Queensland Show 2005");
ok(is_holiday(2005, 8, 17, 'QLD'), "Queensland Show 2005");
ok(is_holiday(2006, 8, 16, 'QLD'), "Queensland Show 2006");
ok(is_holiday(2007, 8, 15, 'QLD'), "Queensland Show 2007");
ok(is_holiday(2015, 8, 12, 'QLD'), "Queensland Show 2015");
ok(is_holiday(2004, 10, 4, 'WA'), "WA Queens Birthday 2004");
ok(is_holiday(2005, 9, 26, 'WA'), "WA Queens Birthday 2005");
ok(is_holiday(2006, 10, 2, 'WA'), "WA Queens Birthday 2006");
ok(is_holiday(2007, 10, 1, 'WA'), "WA Queens Birthday 2007");
ok(is_holiday(2008, 9, 29, 'WA'), "WA Queens Birthday 2008");
ok(is_holiday(2009, 9, 28, 'WA'), "WA Queens Birthday 2009");
ok(is_holiday(2010, 9, 27, 'WA'), "WA Queens Birthday 2010");
ok(is_holiday(2011, 9, 28, 'WA'), "WA Queens Birthday 2011");
ok(is_holiday(2012, 10, 1, 'WA'), "WA Queens Birthday 2012");
ok(is_holiday(2013, 9, 30, 'WA'), "WA Queens Birthday 2013");
ok(is_holiday(2014, 9, 29, 'WA'), "WA Queens Birthday 2014");
ok(is_holiday(2015, 9, 28, 'WA'), "WA Queens Birthday 2015");
ok(is_holiday(2016, 9, 26, 'WA'), "WA Queens Birthday 2016");
ok(is_holiday(2017, 9, 25, 'WA'), "WA Queens Birthday 2017");
ok(is_holiday(2018, 9, 24, 'WA'), "WA Queens Birthday 2018");
ok(is_holiday(2019, 9, 30, 'WA'), "WA Queens Birthday 2019");
ok(is_holiday(2020, 9, 28, 'WA'), "WA Queens Birthday 2020");
ok(is_holiday(2021, 9, 27, 'WA'), "WA Queens Birthday 2021");
ok(is_holiday(2022, 9, 26, 'WA'), "WA Queens Birthday 2022");
ok(is_holiday(2023, 9, 25, 'WA'), "WA Queens Birthday 2023");
my ($year) = (localtime(time))[5] + 1900 + 1;
eval { is_holiday($year, 1, 1, 'WA'); };
ok($@ eq '', "WA Queens Birthday next year ($year)");
eval { is_holiday($year + 5, 1, 1, 'WA'); };
ok($@ =~ /^Don't know how to calculate Queen's Birthday in WA for this year/, "Attempting to calculate WA Queens Birthday too far in the future throws exception");
ok(is_holiday(2004, 10, 1, 'TAS', { 'holidays' => [ 'Burnie Show' ]}), "Burnie Show 2004");
ok(is_holiday(2016, 9, 30, 'TAS', { 'holidays' => [ 'Burnie Show' ]}), "Burnie Show 2016");
ok(not(is_holiday(2004, 10, 1, 'TAS', { 'holidays' => [ 'Agfest' ]})), "Not Burnie Show 2004");
ok(is_holiday(2005, 10, 3, 'NSW'), "NSW Labour Day 2005");
ok(is_holiday(2005, 10, 3, 'NSW'), "ACT Labour Day 2005");
ok(is_holiday(2006, 10, 2, 'SA'), "SA Labour Day 2005");
ok(is_holiday(2004, 10, 7, 'TAS', { 'holidays' => ['Launceston Show','Burnie Show']}), "Launceston Show 2004");
ok(not(is_holiday(2004, 10, 7, 'TAS', { 'holidays' => ['Burnie Show']})), "Not Launceston Show 2004");
ok(is_holiday(2004, 10, 15, 'TAS', { 'holidays' => ['Burnie Show','Flinders Island Show']}), "Flinders Island Show 2004");
ok(not(is_holiday(2004, 10, 15, 'TAS', { 'holidays' => ['Burnie Show']})), "Not Flinders Island Show 2004");
ok(is_holiday(2004, 10, 21, 'TAS', { 'holidays' => ['Burnie Show','Hobart Show']}), "Hobart Show 2004");
ok(not(is_holiday(2004, 10, 21, 'TAS', { 'holidays' => ['Burnie Show']})), "Not Hobart Show 2004");
ok(is_holiday(2004, 11, 1, 'TAS', { 'holidays' => ['Recreation Day']}), "Recreation Day 2004 in Northern Tasmania");
ok(not(is_holiday(2004, 11, 1, 'TAS', { 'holidays' => ['Devonport Show']})), "Not Recreation Day anywhere else in 2004");
ok(not(is_holiday(2004, 11, 1, 'TAS')), "Not Recreation Day 2004");
ok(is_holiday(2005, 11, 1, 'VIC'), "Melbourne Cup 2005");
ok(not(is_holiday(2005, 11, 1, 'VIC', { 'no_melbourne_cup' => 1 })), "No Melbourne Cup 2005");
ok(is_holiday(2006, 11, 7, 'VIC', { 'no_melbourne_cup' => 0 }), "Melbourne Cup 2006");
ok(is_holiday(2004, 11, 26, 'TAS', { 'holidays' => ['Devonport Show']}), "Devonport Show 2004");
ok(is_holiday(2005, 11, 25, 'TAS', { 'holidays' => ['Devonport Show']}), "Devonport Show 2005");
ok(is_holiday(2006, 12, 1, 'TAS', { 'holidays' => ['Devonport Show']}), "Devonport Show 2006");
ok(not(is_holiday(2006, 12, 1, 'TAS', { 'holidays' => ['Recreation Day']})), "Not Devonport Show 2006");
ok(is_holiday(2005, 12, 27, 'VIC'), "Extra Christmas 2005");
ok(is_holiday(2020, 12, 28, 'NSW'), "Additional Day 2020");
ok(is_holiday(2021, 12, 28, 'NSW'), "Additional Day 2021");
ok(is_holiday(2022, 12, 28, 'NSW'), "Additional Day 2022");
ok(not(is_holiday(2009, 12, 28, 'NSW')), "No Additional Day 2009");
ok(not(is_holiday(2005, 12, 28, 'NSW')), "No Additional Day 2005");
ok(not(is_holiday(2004, 12, 29, 'NSW')), "No Additional Day 2004");
ok(is_holiday(2015, 10, 2, 'VIC'), "Grand Final Eve 2015");
ok(is_holiday(2016, 9, 30, 'VIC'), "Grand Final Eve 2016");
ok(is_holiday(2017, 9, 29, 'VIC'), "Grand Final Eve 2017");
ok(is_holiday(2018, 9, 28, 'VIC'), "Grand Final Eve 2018");
ok(is_holiday(2019, 9, 27, 'VIC'), "Grand Final Eve 2019");
ok(is_holiday(2020, 10, 23, 'VIC'), "Grand Final Eve / Thank you 2020");
ok(is_holiday(2021, 9, 24, 'VIC'), "Grand Final Eve 2021");
eval { is_holiday($year + 2, 1, 1, 'VIC'); };
ok($@ =~ /^Don't know how to calculate Grand Final Eve Day/, "Attempting to calculate Grand Final Eve too far in the future throws exception");
