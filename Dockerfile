ARG IMAGE=intersystemsdc/irishealth-community:latest
FROM $IMAGE

WORKDIR /home/irisowner/irisdev
#RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp

RUN pip3 install fhirpy
RUN pip3 install tabulate

# run iris and initial 
RUN --mount=type=bind,src=.,dst=. \
    iris start IRIS && \
    iris session IRIS < scripts/iris.script && \
    iris stop IRIS quietly
