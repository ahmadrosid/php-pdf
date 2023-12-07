FROM rust as planner
WORKDIR /app
COPY . .
RUN apt-get update \
    && apt-get install -y gnupg gosu curl ca-certificates zip unzip git supervisor sqlite3 libcap2-bin libpng-dev dnsutils \
    # && curl -sS 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c' | gpg --dearmor | tee /usr/share/keyrings/ppa_ondrej_php.gpg > /dev/null \
    # Ubuntu 22.04
    #&& echo "deb [signed-by=/usr/share/keyrings/ppa_ondrej_php.gpg] https://ppa.launchpadcontent.net/ondrej/php/ubuntu jammy main" > /etc/apt/sources.list.d/ppa_ondrej_php.list \
    # Ubuntu 20.04
    # && echo "deb [signed-by=/usr/share/keyrings/ppa_ondrej_php.gpg] https://ppa.launchpadcontent.net/ondrej/php/ubuntu focal main" > /etc/apt/sources.list.d/ppa_ondrej_php.list \
    && apt-get install software-properties-common
    && add-apt-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y php8.2-cli php8.2-dev \
    libfontconfig1-dev \
    build-essential \
    mupdf-tools \
    unzip \
    clang
RUN cargo install cargo-chef
RUN cargo chef prepare --recipe-path recipe.json

# Build dependencies
FROM rust:alpine3.18 as cacher
WORKDIR /app
RUN cargo install cargo-chef
COPY --from=planner /app/recipe.json recipe.json

RUN apt-get update \
    && apt-get install -y gnupg gosu curl ca-certificates zip unzip git supervisor sqlite3 libcap2-bin libpng-dev dnsutils \
    # && curl -sS 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c' | gpg --dearmor | tee /usr/share/keyrings/ppa_ondrej_php.gpg > /dev/null \
    # Ubuntu 22.04
    #&& echo "deb [signed-by=/usr/share/keyrings/ppa_ondrej_php.gpg] https://ppa.launchpadcontent.net/ondrej/php/ubuntu jammy main" > /etc/apt/sources.list.d/ppa_ondrej_php.list \
    # Ubuntu 20.04
    # && echo "deb [signed-by=/usr/share/keyrings/ppa_ondrej_php.gpg] https://ppa.launchpadcontent.net/ondrej/php/ubuntu focal main" > /etc/apt/sources.list.d/ppa_ondrej_php.list \
    && apt-get install software-properties-common
    && add-apt-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y php8.2-cli php8.2-dev \
    libfontconfig1-dev \
    build-essential \
    mupdf-tools \
    unzip \
    clang

RUN cargo chef cook --release --recipe-path recipe.json
COPY . .
RUN cargo build --release
RUN php -d "extension=/app/target/release/libphp_pdf.so" test.php

# Run into debian 11
FROM serversideup/php:8.1-fpm-nginx
COPY --from=cacher /app/target/release/libphp_pdf.so /app/libphp_pdf.so

CMD ["php"]