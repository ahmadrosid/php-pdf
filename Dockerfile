FROM php:8.1-cli

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libfontconfig1-dev \
    mupdf-tools \
    unzip \
    clang \
    autoconf
    # && apt-get clean \
    # && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# apt install software-properties-common libfontconfig1-dev mupdf-tools gperf clang php8.1-dev autoconf unzip
# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Set environment variables for Rust
ENV PATH="/root/.cargo/bin:${PATH}"
ENV RUSTUP_HOME="/root/.rustup"
ENV CARGO_HOME="/root/.cargo"

# Copy the PHP extension source code
COPY . /usr/src/php/ext/php-pdf

# Set the working directory
WORKDIR /usr/src/php/ext/php-pdf

RUN cargo build --release

RUN cp /usr/src/php/ext/php-pdf/target/release/libphp_pdf.so $(pecl config-get ext_dir)/libphp_pdf.so
RUN echo "extension=libphp_pdf.so" > /usr/local/etc/php/conf.d/php-pdf.ini
RUN rm -rf /usr/src/php/ext/php-pdf/target

RUN apt-get remove cargo -y
RUN apt-get autoremove -y
RUN apt-get remove build-essential curl git libfontconfig1-dev mupdf-tools unzip clang autoconf -y

RUN php /usr/src/php/ext/php-pdf/test.php

# get the container id from docker ps
# docker cp 1874713bde93:/usr/src/php/ext/php-pdf/target/release/libphp_pdf.so .
# docker exec -it 1874713bde93 bash