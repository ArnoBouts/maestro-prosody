FROM prosody/prosody

USER root

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
		mercurial \
		ca-certificates \
	&& hg clone https://hg.prosody.im/prosody-modules/ /usr/lib/prosody-modules \
	&& apt-get autoremove -y mercurial \
	&& rm -rf /var/lib/apt/lists/*

ADD ./config/prosody.cfg.lua /etc/prosody
RUN chown prosody /etc/prosody/prosody.cfg.lua

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["prosody"]

USER prosody
