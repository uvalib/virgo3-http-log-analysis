#
# pipeline to process the virgo http logs into something meaningfull
#

SOURCE_DIR=logs
RESULTS_DIR=results
INTERESTING_SERVERS="vbt03 vbt04"

# the interesting result sets
for i in $INTERESTING_SERVERS; do

   mkdir -p $RESULTS_DIR/$i

   # split the requests up by query path
   #./scripts/process-requests.ksh $SOURCE_DIR/$i $RESULTS_DIR/$i

   # lastly, summerize by month
   ./scripts/rollup-requests.ksh $RESULTS_DIR/$i

done

#
# end of file
#
