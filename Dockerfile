ARG NODE_VERSION=18

FROM node:${NODE_VERSION}-bullseye-slim

ENV PNPM_HOME="/root/.local/share/pnpm"
ENV PATH="${PATH}:${PNPM_HOME}"

RUN npm install -g pnpm \
    && npm cache clean -force

RUN apt-get update \
  && apt-get install -y \
  ca-certificates \
  fonts-liberation \
  libasound2 \
  libatk-bridge2.0-0 \
  libatk1.0-0 \
  libc6 \
  libcairo2 \
  libcups2 \
  libdbus-1-3 \
  libexpat1 \
  libfontconfig1 \
  libgbm1 \
  libgcc1 \
  libglib2.0-0 \
  libgtk-3-0 \
  libnspr4 \
  libnss3 \
  libpango-1.0-0 \
  libpangocairo-1.0-0 \
  libstdc++6 \
  libx11-6 \
  libx11-xcb1 \
  libxcb1 \
  libxcomposite1 \
  libxcursor1 \
  libxdamage1 \
  libxext6 \
  libxfixes3 \
  libxi6 \
  libxrandr2 \
  libxrender1 \
  libxss1 \
  libxtst6 \
  lsb-release \
  wget \
  xdg-utils \
  dumb-init \
  procps \
  && apt-get clean

COPY ./app /app

WORKDIR /app

ARG TARGETPLATFORM
ARG TARGETARCH
ARG BUILDPLATFORM

RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM, TARGETARCH=$TARGETARCH"

# Install puppeteer and chromium binaries
# linux/arm64
#  https://snapshot.debian.org/binary/chromium/
RUN <<-EOF
    if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
      echo "deb http://snapshot.debian.org/archive/debian-security/20230721T050816Z bullseye-security main" >> /etc/apt/sources.list \
      && apt-get -o Acquire::Check-Valid-Until=false update \
      && apt-get install -y --no-install-recommends chromium-common=115.0.5790.98-1~deb11u1 chromium=115.0.5790.98-1~deb11u1 \
      && apt-get clean \
      && PUPPETEER_SKIP_DOWNLOAD=true npm install \
      && npm cache clean -force \
      && echo "PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium" >> /etc/bash.bashrc; \
    elif [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
      npm install \
      && npm cache clean -force; \
    fi
EOF

ENTRYPOINT ["dumb-init", "--"]

CMD ["node", "index.js"]
