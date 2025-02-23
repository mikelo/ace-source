FROM docker.io/alpine/git as git
WORKDIR /tmp
RUN git clone https://github.com/mikelo/ace-source
FROM cp.icr.io/cp/appc/ace:13.0.2.0-r1 AS ace
# USER aceuser
ENV LICENSE=accept
ENV DATA=/tmp/data
ENV SKIP=""
# VOLUME [ "/tmp/data" ]
COPY --from=git --chown=aceuser:mqbrkrs /tmp/ace-source /tmp/coffee
# RUN . /opt/ibm/ace-13/server/bin/mqsiprofile && jar xvf gradle.zip > /dev/null && chmod +x gradle-8.13-milestone-3/bin/gradle && \
# ibmint package --input-path coffee --output-bar-file coffee.bar --overrides-file coffee/overrides.properties && \
# mqsicreateworkdir /tmp/work-dir && ibmint deploy --input-bar-file coffee.bar --output-work-directory /tmp/work-dir
WORKDIR /tmp/coffee
# ADD --chown=aceuser:mqbrkrs https://services.gradle.org/distributions/gradle-8.13-milestone-3-bin.zip gradle.zip
ENV MQSI_JARPATH=$MQSI_JARPATH:/tmp/coffee/ACME_CoffeeRoasters_Java
RUN . /opt/ibm/ace-13/server/bin/mqsiprofile && ibmint package --input-path . --output-bar-file coffee.bar --project ACME_CoffeeRoasters_Application --project ACME_CoffeeRoasters_Java --project ACME_CoffeeRoasters_UnitTest --project ACME_CoffeeRoasters_ComponentTest && mqsicreateworkdir /tmp/work-dir && ibmint deploy --input-bar-file coffee.bar --output-work-directory /tmp/work-dir
ADD entrypoint.sh .
EXPOSE 7600
EXPOSE 7800
ENTRYPOINT [ "/tmp/coffee/entrypoint.sh" ]
