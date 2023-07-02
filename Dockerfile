ARG IMAGE=intersystemsdc/irishealth-community:latest
FROM $IMAGE

ARG openai_api_key
ENV OPENAI_API_KEY $openai_api_key
RUN echo $OPENAI_API_KEY

WORKDIR /home/irisowner/irisdev
#RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp

RUN pip3 install fhirpy
RUN pip3 install tabulate
RUN pip3 install openai

# run iris and initial 
RUN --mount=type=bind,src=.,dst=. \
    iris start IRIS && \
    iris session IRIS < scripts/iris.script && \
    iris stop IRIS quietly
