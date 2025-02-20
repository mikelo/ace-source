FROM docker.io/alpine/git as git
WORKDIR /tmp
RUN git clone https://gitlab.com/mik3lo/acepoc.git
FROM cp.icr.io/cp/appc/ace:13.0.2.0-r1 AS ace
# USER aceuser
ENV LICENSE=accept
ENV DATA=/tmp/data
ENV SKIP=""
WORKDIR /tmp
# VOLUME [ "/tmp/data" ]
ADD --chown=aceuser:aceuser https://services.gradle.org/distributions/gradle-8.13-milestone-3-bin.zip gradle.zip
COPY --from=git /tmp/acepoc acepoc
RUN . /opt/ibm/ace-13/server/bin/mqsiprofile && jar xvf gradle.zip > /dev/null && chmod +x gradle-8.13-milestone-3/bin/gradle && \
ibmint package --input-path acepoc --output-bar-file acepoc.bar --overrides-file acepoc/overrides.properties && \
mqsicreateworkdir /tmp/work-dir && ibmint deploy --input-bar-file acepoc.bar --output-work-directory /tmp/work-dir
ADD entrypoint.sh .
EXPOSE 7600
EXPOSE 7800
ENTRYPOINT [ "/tmp/entrypoint.sh" ]
