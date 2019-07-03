#
# script to split the request information by URL
#

if [ $# -ne 2 ]; then
   echo "use: $(basename $0) <infile> <outdir>" >&2
   exit 1
fi

INFILE=$1
OUTDIR=$2

if [ ! -f $INFILE ]; then
   echo "ERROR: $INFILE does not exist or is not readable" >&2
   exit 1
fi

if [ ! -d $OUTDIR ]; then
   echo "ERROR: $OUTDIR does not exist or is not readable" >&2
   exit 1
fi

# Count number of data points
N=$(grep "\"GET " $INFILE | wc -l | awk '{print $1}')

BASENAME=$(basename $INFILE)

# root query
grep "\"GET /\"" $INFILE | awk '{print $4, $6, $7}' > $OUTDIR/$BASENAME.path.root

# all the other paths we are interested in
INTERESTING_PATHS="account articles catalog fedora folder music shelf_browse video"

# specific path queries
for i in $INTERESTING_PATHS; do
   grep "\"GET /$i" $INFILE | awk '{print $4, $6, $7}' > $OUTDIR/$BASENAME.path.$i
done

# create the summary file

SUMMARY_FILE=$OUTDIR/$BASENAME.summary
rm $SUMMARY_FILE > /dev/null 2>&1

echo "$N total requests" >> $SUMMARY_FILE

for i in root $INTERESTING_PATHS; do
   N=$(wc -l $OUTDIR/$BASENAME.path.$i | awk '{print $1}')
   printf " %-15s : %d\n" $i $N >> $SUMMARY_FILE
done

# calculate the maximum number of requests per hour (exclude root queries)
grep "\"GET /" $INFILE | grep -v "\"GET /\"" | awk '{print $4}' | awk -F: '{print $2}' | sort | uniq -c | sort -n | tail -1 | awk '{ printf "\nMax requests/hour: %s (%s:00 hours). This excludes root/healthchecks\n", $1, $2}' >> $SUMMARY_FILE


exit 0

#
# end of file
#
