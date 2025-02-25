#!/bin/sh
source /opt/ibm/ace-13/server/bin/mqsiprofile

runtests () {
    # rm -fr /tmp/work-dir/run /tmp/test-project 2>/dev/null
    # ibmint generate tests --recorded-messages /tmp/$1/src/main/resources --output-test-project test-project --java-class com.ibm.dev.$1 
    # cd /tmp/test-project && /tmp/gradle-8.13-milestone-3/bin/gradle
    # cp -vr /tmp/test-project /tmp/work-dir/run 
    IntegrationServer --work-dir /tmp/work-dir --test-project $1 --start-msgflows false --default-application-name test-project
    EC=$?
    if [[ $EC != 0 ]]; then
        echo "$1 failed with exit code $EC"
        # exit $EC
    fi    
}

if [[ -z $SKIP ]]; then
    echo "SKIP variable not set! Running tests!"
    runtests ACME_CoffeeRoasters_UnitTest
    runtests ACME_CoffeeRoasters_ComponentTest
fi

IntegrationServer --work-dir /tmp/work-dir --start-msgflows true

