#!/usr/bin/perl
# Just a simple perl script to extract some data for csv plotting

print "blocksize,p99_us,aggrb_kbs,iops\n";

while (<>) {
 $clat_unit=$1 if /^ *clat percentiles \((\w+)\).*$/;
 $bs=$1 if /^randread-([\w\d]+): \(grou.*/;
 $p99=$1 if /^.*99\.00th=\[\s*(\d+)\].*$/;
 $iops=$1 if /^.*iops=(\d+).*$/;
 print bs_unit($bs),", ", time_unit($clat_unit,$p99), ", ", kb_unit($1), ", ", $iops, "\n" if /^.*aggrb=([\.\d]+.+?\/s),.*/;
}


sub kb_unit {
 my ($unit) = (@_);
 return $1 if ($unit =~ /^(.*?)KB\/s/);
 return ($1*1024) if ($unit =~ /^(.*?)MB\/s/);
 return ($1*1024*1024) if ($unit =~ /^(.*?)GB\/s/);
 print "oops on kb_unit: unit=$unit\n";
 exit 4;
}

sub time_unit {
 my ($unit,$num) = (@_);
 return $num if ($unit eq 'usec');
 return $num*1000 if ($unit eq 'msec');
 print "oops on time unit: unit:$unit num:$num\n";
 exit 2;
}

sub bs_unit {
 my ($bs) = (@_);
 return ($1) if ($bs =~ /^(\d+)$/);
 return ($1 * 1024) if ($bs =~ /^(\d+)k$/);
 return ($1 * 1024 * 1024) if ($bs =~ /^(\d+)m$/);
 print "oops on bs unit\n";
 exit 3;
}

__END__


randread-512: (g=0): rw=randread, bs=512-512/512-512/512-512, ioengine=libaio, iodepth=10
fio-2.2.8
Starting 1 process
randread-512: Laying out IO file(s) (1 file(s) / 5120MB)

randread-512: (groupid=0, jobs=1): err= 0: pid=4458: Thu Apr  7 14:59:41 2016
  read : io=12915KB, bw=220291B/s, iops=430, runt= 60034msec
    slat (usec): min=1, max=29, avg= 2.76, stdev= 1.16
    clat (usec): min=124, max=306970, avg=23235.42, stdev=24010.65
     lat (usec): min=129, max=306973, avg=23238.30, stdev=24010.63
    clat percentiles (msec):
     |  1.00th=[    3],  5.00th=[    4], 10.00th=[    5], 20.00th=[    7],
     | 30.00th=[    9], 40.00th=[   11], 50.00th=[   15], 60.00th=[   19],
     | 70.00th=[   26], 80.00th=[   36], 90.00th=[   54], 95.00th=[   73],
     | 99.00th=[  119], 99.50th=[  135], 99.90th=[  176], 99.95th=[  194],
     | 99.99th=[  251]
    bw (KB  /s): min=  138, max=  240, per=100.00%, avg=215.10, stdev=13.99
    lat (usec) : 250=0.01%, 500=0.03%, 750=0.02%
    lat (msec) : 2=0.21%, 4=5.83%, 10=29.49%, 20=26.59%, 50=26.31%
    lat (msec) : 100=9.71%, 250=1.79%, 500=0.01%
  cpu          : usr=0.19%, sys=0.14%, ctx=25835, majf=0, minf=12
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=100.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=25830/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=10

Run status group 0 (all jobs):
   READ: io=12915KB, aggrb=215KB/s, minb=215KB/s, maxb=215KB/s, mint=60034msec, maxt=60034msec

Disk stats (read/write):
  sda: ios=25773/41, merge=0/6, ticks=598327/1341, in_queue=599933, util=99.87%


