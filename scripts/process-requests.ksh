#
# script to process all the log files
#

if [ $# -ne 2 ]; then
   echo "use: $(basename $0) <in directory> <out directory>" >&2
   exit 1
fi

INDIR=$1
OUTDIR=$2

if [ ! -d $INDIR ]; then
   echo "ERROR: $INDIR does not exist or is not readable" >&2
   exit 1
fi

if [ ! -d $OUTDIR ]; then
   echo "ERROR: $OUTDIR does not exist or is not readable" >&2
   exit 1
fi

TMPFILE=/tmp/requests.$$

# find all the files
find $INDIR -name search_ssl_access_log-* | sort > $TMPFILE

for file in $(<$TMPFILE); do
   echo "processing $file..."
   ./scripts/split-requests.ksh $file $OUTDIR
done

rm $TMPFILE

exit 0

#
# end of file
#
