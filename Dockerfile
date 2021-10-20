FROM tier4/scenario_simulator_v2:galactic

COPY build_image /build_image
COPY test_image /test_image
COPY entrypoint.sh /entrypoint.sh

RUN apk add --update --no-cache docker
RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["sh", "/entrypoint.sh"]