FROM prosody/prosody
# FROM_DIGEST sha256:7175ff3c3b01aa18637cec84910902f418f4d2d36dcd85489cb044d76ddbcafb

USER root

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
		mercurial \
		ca-certificates \
		lua-ldap \
	&& hg clone https://hg.prosody.im/prosody-modules/ /usr/lib/prosody-modules \
	&& apt-get remove -y mercurial \
	&& rm -rf /var/lib/apt/lists/*

ADD ./config/prosody.cfg.lua /etc/prosody
RUN chown prosody /etc/prosody/prosody.cfg.lua

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["prosody"]

USER prosody
