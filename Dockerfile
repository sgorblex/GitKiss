FROM alpine
ARG OWNER
ARG PUBKEY
RUN test -n $OWNER
RUN test -n "$PUBKEY"
COPY "$PUBKEY" /
RUN apk update
RUN apk add --no-cache git git-daemon openssh-server curl sudo
RUN ssh-keygen -A
RUN curl -o /root/install.sh https://raw.githubusercontent.com/sgorblex/GitKiss/master/install.sh
RUN chmod +x /root/install.sh
RUN sed -i '/useradd/d' /root/install.sh
RUN mkdir /srv/gitkiss
RUN printf "uselesspassword\nuselesspassword\n" | adduser -h /srv/gitkiss gitkiss
RUN /root/install.sh -k "/$PUBKEY" -o "$OWNER"
RUN printf "/srv/gitkiss/gitkiss/daemon.sh &\necho 'Starting SSHD'\n/usr/sbin/sshd -D\n" > daemon.sh
CMD sh daemon.sh
