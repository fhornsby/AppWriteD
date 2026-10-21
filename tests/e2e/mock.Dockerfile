# The sdk-generator mock server, built from a vendor directory installed on the
# host (composer install), so the build itself needs no network access.
FROM phpswoole/swoole:6.2.2-php8.4-alpine
RUN mkdir -p /storage/cache
WORKDIR /usr/src/code
COPY vendor /usr/src/code/vendor
COPY src /usr/src/code/src
COPY app /usr/src/code/app
EXPOSE 80
CMD ["php", "-e", "app/http.php"]
