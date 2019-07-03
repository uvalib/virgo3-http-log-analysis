#
# script to process all the request files and generate summary information
#

if [ $# -ne 1 ]; then
   echo "use: $(basename $0) <in directory>" >&2
   exit 1
fi

INDIR=$1

if [ ! -d $INDIR ]; then
   echo "ERROR: $INDIR does not exist or is not readable" >&2
   exit 1
fi

TMPFILE=/tmp/rollup-requests.$$

# find all the files
find $INDIR -name *.summary | sort > $TMPFILE

SUMMARY_FILE=$INDIR/summary.requests
rm $SUMMARY_FILE > /dev/null 2>&1

for file in $(<$TMPFILE); do
   DATE=$(basename $file ".summary" | awk -F\- '{print $2}')
   TOTAL=$(grep "total requests" $file | awk '{print $1}')
   echo "$DATE total requests: $TOTAL"  >> $SUMMARY_FILE
done

rm $TMPFILE

# calculate the average daily request count
grep "total requests" $SUMMARY_FILE | awk '{printf "%s + ", $4}' > $TMPFILE
COUNT=$(grep "total requests" $SUMMARY_FILE | wc -l | awk '{print $1}')
echo "0" >> $TMPFILE
SUM=$(cat $TMPFILE | bc)
AVG=$(echo "scale=2; $SUM / $COUNT" | bc)

echo "" >> $SUMMARY_FILE
echo "Average daily requests: $AVG" >> $SUMMARY_FILE
grep "total requests" $SUMMARY_FILE | awk '{print $4, $1}' | sort -n | tail -1 | awk '{printf "Most requests: %s (on %s)\n", $1, $2}' >> $SUMMARY_FILE

rm $TMPFILE

echo "summary available $SUMMARY_FILE"

exit 0

#
# end of file
#
