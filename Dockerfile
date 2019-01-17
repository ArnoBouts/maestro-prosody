FROM prosody/prosody
# FROM_DIGEST sha256:c31d19d29b82db5163721f2f2b18e5131a3a4f73828106ead49e949606424bf2

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
