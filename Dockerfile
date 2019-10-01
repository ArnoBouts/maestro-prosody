FROM prosody/prosody
# FROM_DIGEST sha256:cee9be6f82a6c07274a0373f195a7a362bc7c4b27d878ac9d106cf74e18f4c8a

USER root

COPY stretch-backports.list /etc/apt/sources.list.d/

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		mercurial \
		ca-certificates \
        && apt-get -t stretch-backports install -y --no-install-recommends lua-ldap \
	&& hg clone https://hg.prosody.im/prosody-modules/ /usr/lib/prosody-modules \
	&& apt-get remove -y mercurial \
	&& rm -rf /var/lib/apt/lists/*

ADD ./config/prosody.cfg.lua /var/lib/prosody
RUN chown -R prosody /var/lib/prosody

RUN ln -sf /var/lib/prosody/prosody.cfg.lua /etc/prosody/prosody.cfg.lua

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["prosody"]

USER prosody
