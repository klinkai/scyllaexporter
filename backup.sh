#! /bin/sh

set -e
set -o pipefail

if [ "${S3_ACCESS_KEY_ID}" = "**None**" ]; then
  echo "You need to set the S3_ACCESS_KEY_ID environment variable."
  exit 1
fi

if [ "${S3_SECRET_ACCESS_KEY}" = "**None**" ]; then
  echo "You need to set the S3_SECRET_ACCESS_KEY environment variable."
  exit 1
fi

if [ "${S3_BUCKET}" = "**None**" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

if [ "${SCYLLADB_HOST}" = "**None**" ]; then
    echo "You need to set the SCYLLADB_HOST environment variable."
    exit 1
fi

if [ "${SCYLLADB_USER}" = "**None**" ]; then
  echo "You need to set the SCYLLADB_USER environment variable."
  exit 1
fi

if [ "${SCYLLADB_PASSWORD}" = "**None**" ]; then
  echo "You need to set the SCYLLADB_PASSWORD environment variable ."
  exit 1
fi


if [ "${SCYLLADB_KEYSPACE}" = "**None**" ]; then
  echo "You need to set the SCYLLADB_KEYSPACE environment variable ."
  exit 1
fi


if [ "${SCYLLADB_PORT}" = "**None**" ]; then
  echo "You need to set the SCYLLADB_PORT environment variable ."
  exit 1
fi

if [ "${S3_ENDPOINT}" == "**None**" ]; then
  AWS_ARGS=""
else
  AWS_ARGS="--endpoint-url ${S3_ENDPOINT}"
fi

# env vars needed for aws tools
export AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$S3_REGION

echo "Creating dump of ${SCYLLADB_KEYSPACE} database from ${SCYYLADB_HOST}..."

/backup/cql-exporter.sh -h $SCYLLADB_HOST -u $SCYLLADB_USER -p $SCYLLADB_PASSWORD -k $SCYLLADB_KEYSPACE -po $SCYLLADB_PORT

gzip /backup/"${SCYLLADB_KEYSPACE}.CQL"

echo "Uploading dump to $S3_BUCKET"

cat /backup/"${SCYLLADB_KEYSPACE}.CQL.gz" | aws $AWS_ARGS s3 cp - s3://$S3_BUCKET/$S3_PREFIX/${SCYLLADB_KEYSPACE}_$(date +"%Y-%m-%dT%H:%M:%SZ").CQL.gz || exit 2

rm -rf /backup/"${SCYLLADB_KEYSPACE}.CQL.gz"

echo "ScyllaDB backup uploaded successfully"
