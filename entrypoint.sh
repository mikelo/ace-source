#!/bin/sh
source /opt/ibm/ace-13/server/bin/mqsiprofile

runtests () {
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

