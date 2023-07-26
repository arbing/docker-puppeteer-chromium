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
  && apt-get clean

COPY ./app /app

WORKDIR /app

# Install puppeteer and chromium binaries
RUN npm install \
    && npm cache clean -force

ENTRYPOINT ["dumb-init", "--"]

CMD ["node", "index.js"]
