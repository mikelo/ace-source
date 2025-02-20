#!/bin/sh
source /opt/ibm/ace-13/server/bin/mqsiprofile

runtests () {
    ibmint generate tests --recorded-messages $DATA --output-test-project /tmp/test-project --java-class com.ibm.ClassName 
    cd /tmp/test-project && /tmp/gradle-8.13-milestone-3/bin/gradle
    cp -vr /tmp/test-project /tmp/work-dir/run 
    IntegrationServer --work-dir /tmp/work-dir --test-project test-project --start-msgflows false
    EC=$?
    if [[ $EC != 0 ]]; then
        echo "tests failed with exit code $EC"
        exit $EC
    fi
}

if [[ -z $SKIP ]]; then
    echo "SKIP variable not set! Running tests!"
    runtests
fi

IntegrationServer --work-dir /tmp/work-dir --start-msgflows true

