DESTDIR :=
SYSTEMD := $(DESTDIR)/usr/lib/systemd/system/
USRBIN  := $(DESTDIR)/usr/bin/
SRC     := src/
UNITS   := $(SRC)systemd/

install:
	install -Dm755 $(SRC)gitdaemon.sh $(USRBIN)gitdaemon
	install -Dm755 $(SRC)sitedeploy.sh $(USRBIN)sitedeploy
	install -Dm755 $(SRC)renew-certbot.sh $(USRBIN)renew-certbot
	install -Dm755 $(SRC)new-git.sh $(USRBIN)new-git
	install -Dm644 $(UNITS)gitdaemon.service $(SYSTEMD)gitdaemon.service
	install -Dm644 $(UNITS)sshe.service $(SYSTEMD)sshe.service
	install -Dm644 $(UNITS)renew-certbot.timer $(SYSTEMD)renew-certbot.timer
	install -Dm644 $(UNITS)renew-certbot.service $(SYSTEMD)renew-certbot.service
	install -Dm644 $(UNITS)sitedeploy.service $(SYSTEMD)sitedeploy.service
