#!/bin/sh
source /opt/ibm/ace-13/server/bin/mqsiprofile

runtests () {
    # ibmint generate tests --recorded-messages $DATA --output-test-project /tmp/test-project --java-class com.ibm.ClassName 
    # cd /tmp/coffee/ACME_CoffeeRoasters_UnitTest && /tmp/coffee/gradle-8.13-milestone-3/bin/gradle
    # cp -vr /tmp/coffee/ACME_CoffeeRoasters_UnitTest /tmp/work-dir/run 
    # ibmint deploy --input-path /tmp/coffee/ 
    ibmint create node Transform && ibmint start node Transform
    IntegrationServer --work-dir /tmp/work-dir --test-project ACME_CoffeeRoasters_UnitTest --start-msgflows false
    EC=$?
    if [[ $EC != 0 ]]; then
        echo "ACME_CoffeeRoasters_UnitTest failed with exit code $EC"
        exit $EC
    fi
    # rm -fr /tmp/work-dir/run && cd /tmp/coffee/ACME_CoffeeRoasters_ComponentTest && /tmp/coffee/gradle-8.13-milestone-3/bin/gradle
    # cp -vr /tmp/coffee/ACME_CoffeeRoasters_ComponentTest /tmp/work-dir/run
    IntegrationServer --work-dir /tmp/work-dir --test-project ACME_CoffeeRoasters_ComponentTest --start-msgflows false
    EC=$?
    if [[ $EC != 0 ]]; then
        echo "ACME_CoffeeRoasters_ComponentTest failed with exit code $EC"
        # exit $EC
    fi
    ibmint stop node Transform
}

if [[ -z $SKIP ]]; then
    echo "SKIP variable not set! Running tests!"
    runtests
fi

IntegrationServer --work-dir /tmp/work-dir --start-msgflows true

