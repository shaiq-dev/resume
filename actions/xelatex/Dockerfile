FROM debian:latest

LABEL "maintainer"="Shaiq Kar <shaiqkar@gmail.com>"
LABEL "repository"="https://github.com/shaiq-dev/Resume"
LABEL "homepage"="https://github.com/shaiq-dev/Resume"

LABEL "com.github.actions.name"="Convert to PDF"
LABEL "com.github.actions.description"="Convert documents to PDF with xelatex."
LABEL "com.github.actions.icon"="code"
LABEL "com.github.actions.color"="blue"

ENV DEBIAN_FRONTEND noninteractive

# Install all TeX and LaTeX dependencies
RUN apt-get update && \
    add-apt-repository universe && \
    apt-get install --yes --no-install-recommends \
    texlive-full && \
    apt-get autoclean && apt-get --purge --yes autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]