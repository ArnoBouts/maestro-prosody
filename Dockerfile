FROM prosody/prosody
# FROM_DIGEST sha256:6fc712aac8ca7cf1c2e7888c1c2c143e72f2d063eaa946ee42fa7bb989ae390c

USER root

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
		mercurial \
		ca-certificates \
		lua-ldap \
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
