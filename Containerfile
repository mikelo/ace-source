FROM docker.io/alpine/git as git
WORKDIR /tmp
RUN git clone https://github.com/mikelo/ace-source
FROM cp.icr.io/cp/appc/ace:13.0.2.0-r1 AS ace
# USER aceuser
ENV LICENSE=accept
ENV DATA=/tmp/data
ENV SKIP=""
# VOLUME [ "/tmp/data" ]
COPY --from=git --chown=aceuser:mqbrkrs /tmp/ace-source/ /tmp/

WORKDIR /tmp/

ENV MQSI_JARPATH=$MQSI_JARPATH:/tmp/ACME_CoffeeRoasters_Java

RUN . /opt/ibm/ace-13/server/bin/mqsiprofile && ibmint package --input-path . --output-bar-file coffee.bar --project ACME_CoffeeRoasters_Application --project ACME_CoffeeRoasters_Java --project ACME_CoffeeRoasters_UnitTest --project ACME_CoffeeRoasters_ComponentTest && mqsicreateworkdir /tmp/work-dir && ibmint deploy --input-bar-file coffee.bar --output-work-directory /tmp/work-dir

ADD entrypoint.sh .
EXPOSE 7600
EXPOSE 7800
ENTRYPOINT [ "/tmp/entrypoint.sh" ]
