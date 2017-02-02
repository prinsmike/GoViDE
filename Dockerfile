FROM golang:alpine
MAINTAINER prinsmike

# Run the containers and start vim imediately.
# docker run -itv $GOPATH/src:/go/src --rm prinsmike/govide
# or run with a bash shell and start vim manually.
# docker run -itv $GOPATH/src:/go/src --rm prinsmike/govide /bin/bash

ADD fs/ /tmp

RUN apk update																			&& \
# Add permanent.
apk add --update git mercurial gcc ctags bash curl sudo bash-completion openssh			&& \
# Add temporary.
apk add --update --virtual build-deps build-base make libxpm-dev						\
	libx11-dev libxt-dev ncurses-dev llvm perl cmake python-dev							&& \
	go get -u -buildmode=exe -ldflags '-s -w'											\
# golang.org
	golang.org/x/tools/cmd/godoc                          								\
	golang.org/x/tools/cmd/goimports                      								\
	golang.org/x/tools/cmd/gorename                       								\
	golang.org/x/tools/cmd/guru                         								\
	golang.org/x/tools/cmd/present                        								\
# github.com
	github.com/rogpeppe/godef                             								\
	github.com/nsf/gocode                                 								\
	github.com/kisielk/errcheck                           								\
	github.com/golang/lint/golint                         								\
	github.com/jstemmer/gotags                            								\
	github.com/derekparker/delve/cmd/dlv												&& \
# Glide (golang package management)
	curl https://glide.sh/get | sh														&& \
# Install Vim.
	cd /tmp																				&& \
	git clone https://github.com/vim/vim												&& \
	cd /tmp/vim																			&& \
	./configure --with-features=huge 													\
		--enable-multibyte																\
		--enable-pythoninterp															\
		--with-python-config-dir=/usr/lib/python2.7/config								\
		--enable-luainterp																\
		--with-luajit																	\
		--with-lua-prefix=/usr/include													\
		--enable-gui=no																	\
		--without-x																		\
		--disable-netbeans																\
		--prefix=/usr																	&& \
	make VIMRUNTIMEDIR=/usr/share/vim/vim80												&& \
	make install																		&& \
# Add govide user.
	mkdir -p /go/src																	&& \
	adduser -h /home/govide -s /bin/bash -g "" -D -u 1000 govide govide					&& \
	echo "ALL						ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers			&& \
# Files.
	mkdir -p /home/govide/.vim/colors /home/govide/.vim/bundle /home/govide/.ssh 		&& \
	mv /tmp/.profile /home/govide/														&& \
	mv /tmp/.bashrc /home/govide/														&& \
	mv /tmp/.vimrc /home/govide/														&& \
	mv /tmp/molokai.vim /home/govide/.vim/colors/molokai.vim							&& \
	chown -R govide:govide /home/govide /go												&& \
# Build YouCompleteMe.
	git clone --depth 1 https://github.com/Valloric/YouCompleteMe.git					\
		/home/govide/.vim/bundle/YouCompleteMe/											&& \
	cd /home/govide/.vim/bundle/YouCompleteMe											&& \
	git submodule update --init --recursive												&& \
	/home/govide/.vim/bundle/YouCompleteMe/install.py --gocode-completer				&& \
# Cleanup.
	apk del build-deps																	&& \
	apk add libsm libice libxt libx11 ncurses											&& \
	rm -rf /var/cache/* /var/log/* /var/tmp/*											&& \
	mkdir /var/cache/apk																&& \
	cd /usr/share/vim/vim80																&& \
	rm -rf /tmp/*

USER govide

ENV GOPATH /go
ENV PATH $PATH:$GOPATH/bin

# Vundle.
RUN	git clone https://github.com/gmarik/vundle /home/govide/.vim/bundle/vundle			&& \
		vim +PluginInstall +qall!

VOLUME /go/src
VOLUME /home/govide/.ssh

WORKDIR /go/src

CMD /bin/bash -c /usr/bin/vim
