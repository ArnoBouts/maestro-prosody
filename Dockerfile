FROM prosody/prosody
# FROM_DIGEST sha256:15ab4c34bdd7ddc80c5e2b9879d1ab7cb2f1e70695c1e590ef7556ca3b42ba89

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
