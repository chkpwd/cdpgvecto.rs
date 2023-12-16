ARG CRUNCHYDATA_VERSION=ubi8-15.5-0
ARG PG_MAJOR=15
ARG ALPINE_VERSION=3.19.0

FROM alpine:${ALPINE_VERSION} as builder

ARG PG_MAJOR
ARG PGVECTORS_TAG=v0.1.11

RUN apk add --no-cache curl alien rpm binutils

WORKDIR /tmp

RUN curl -o pgvectors.deb -sSL "https://github.com/tensorchord/pgvecto.rs/releases/download/${PGVECTORS_TAG}/vectors-pg${PG_MAJOR}-${PGVECTORS_TAG}-$(uname -m)-unknown-linux-gnu.deb" && \
    alien -r pgvectors.deb && \
    rm -f pgvectors.deb

RUN rpm2cpio /tmp/*.rpm | cpio -idmv

ARG CRUNCHYDATA_VERSION
FROM registry.developers.crunchydata.com/crunchydata/crunchy-postgres:${CRUNCHYDATA_VERSION}

ARG PG_MAJOR

COPY --chown=root:root --chmod=755 --from=builder /tmp/usr/lib/postgresql/${PG_MAJOR}/lib/vectors.so /usr/pgsql-${PG_MAJOR}/lib/
COPY --chown=root:root --chmod=755 --from=builder /tmp/usr/share/postgresql/${PG_MAJOR}/extension/vectors*.sql /usr/pgsql-${PG_MAJOR}/share/extension/
COPY --chown=root:root --chmod=755 --from=builder /tmp/usr/share/postgresql/${PG_MAJOR}/extension/vectors.control /usr/pgsql-${PG_MAJOR}/share/extension/

# Default PostgreSQL User
USER 26

COPY app/pgvectors.sql /docker-entrypoint-initdb.d/
