# Build dependencies
FROM rust as builder
WORKDIR /app
RUN apt update \
    && apt install -y gnupg gosu curl ca-certificates zip unzip git supervisor sqlite3 libcap2-bin libpng-dev dnsutils \
    && curl -sS 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c' | gpg --dearmor | tee /usr/share/keyrings/ppa_ondrej_php.gpg > /dev/null \
    # Ubuntu 22.04
    && echo "deb [signed-by=/usr/share/keyrings/ppa_ondrej_php.gpg] https://ppa.launchpadcontent.net/ondrej/php/ubuntu jammy main" > /etc/apt/sources.list.d/ppa_ondrej_php.list \
    # Ubuntu 20.04
    # && echo "deb [signed-by=/usr/share/keyrings/ppa_ondrej_php.gpg] https://ppa.launchpadcontent.net/ondrej/php/ubuntu focal main" > /etc/apt/sources.list.d/ppa_ondrej_php.list \
    && apt update \
    && apt install -y php8.2-cli php8.2-dev \
    libfontconfig1-dev \
    build-essential \
    mupdf-tools \
    unzip \
    clang

COPY . .
RUN cargo build --release
RUN wget --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3"  https://arxiv.org/pdf/2303.12712.pdf
RUN php -d "extension=/app/target/release/libphp_pdf.so" test.php

# Run into debian 11
FROM serversideup/php:8.1-fpm-nginx
COPY --from=builder /app/target/release/libphp_pdf.so /app/libphp_pdf.so
RUN echo "extension=/app/libphp_pdf.so" > /etc/php/8.1/cli/conf.d/php-pdf.ini
