FROM golang:alpine
MAINTAINER Michael Prinsloo

RUN apk update																																&& \
# Add permanent.
apk add --update git mercurial gcc ctags bash	curl														&& \
# Add temporary.
apk add --update --virtual build-deps build-base 	make libxpm-dev									\
	libx11-dev libxt-dev ncurses-dev																 						&& \
	go get -u -buildmode=exe -ldflags '-s -w'																				\
# golang.org
    golang.org/x/tools/cmd/godoc                          												\
    golang.org/x/tools/cmd/goimports                      												\
    golang.org/x/tools/cmd/gorename                       												\
    golang.org/x/tools/cmd/oracle                         												\
    golang.org/x/tools/cmd/present                        												\
# github.com
    github.com/rogpeppe/godef                             												\
    github.com/nsf/gocode                                 												\
    github.com/kisielk/errcheck                           												\
    github.com/golang/lint/golint                         												\
    github.com/jstemmer/gotags                            												\
		github.com/derekparker/delve/cmd/dlv																			&& \
# Glide (golang package management)
	curl https://glide.sh/get | sh																							&& \
# Install Vim.
	cd /tmp																																			&& \
	git clone https://github.com/vim/vim																				&& \
	cd /tmp/vim																																	&& \
	./configure --with-features=huge 																								\
		--enable-multibyte																														\
		--enable-pythoninterp																													\
		--with-python-config-dir=/usr/lib/python2.7/config														\
		--enable-luainterp																														\
		--enable-gui=no																																\
		--without-x																																		\
		--disable-netbeans																														\
		--prefix=/usr																															&& \
	make VIMRUNTIMEDIR=/usr/share/vim/vim80																			&& \
	make install																																&& \
	apk del build-deps																													&& \
	apk add libsm libice libxt libx11 ncurses																		&& \
# Cleanup.
	rm -rf /var/cache/* /var/log/* /var/tmp/*																		&& \
	mkdir /var/cache/apk																												&& \
	cd /usr/share/vim/vim80																											&& \
	rm -rf /tmp/*

CMD /bin/bash -c /usr/bin/vim
