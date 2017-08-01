TERRARIA_USER := terraria
TERRARIA_HOME := /opt/terraria
TERRARIASERVERS := /usr/local/bin/terrariaservers
TERRARIAD := /usr/local/bin/terrariad
TERRARIA_INIT_D := /etc/init.d/terrariad
TERRARIA_SERVICE := /lib/systemd/system/terrariad.service
TERRARIA_COMPLETION := /etc/bash_completion.d/terrariad

install: update
	if [ `grep -c '^$(TERRARIA_USER):' /etc/passwd` = "0" ]; then \
		useradd --system --user-group --create-home --home $(TERRARIA_HOME) $(TERRARIA_USER); \
	fi
	mkdir -p $(TERRARIA_HOME)/servers
	if which systemctl; then \
		systemctl -f enable terrariad.service; \
	else \
		ln -s $(TERRARIAD) $(TERRARIA_INIT_D); \
		update-rc.d terrariad defaults; \
	fi

update:
	install -m 0755 terrariaservers $(TERRARIASERVERS)
	install -m 0755 terrariad $(TERRARIAD)
	install -m 0644 terrariad.completion $(TERRARIA_COMPLETION)
	if which systemctl; then \
		install -m 0644 terrariad.service $(TERRARIA_SERVICE); \
		systemctl daemon-reload; \
	fi

clean:
	if which systemctl; then \
		systemctl -f disable terrariad.service; \
		rm -f $(TERRARIA_SERVICE); \
	else \
		update-rc.d terrariad remove; \
		rm -f $(TERRARIA_INIT_D); \
	fi
	rm -f $(TERRARIASERVERS) $(TERRARIAD) $(TERRARIA_COMPLETION)
