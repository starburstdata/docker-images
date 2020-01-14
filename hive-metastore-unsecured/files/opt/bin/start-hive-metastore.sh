#!/usr/bin/env bash

################################################################################
# Copyright (c) 2018 Starburst Data, Inc. All rights reserved.
#
# All information herein is owned by Starburst Data Inc. and its licensors
# ("Starburst"), if any.  This software and the concepts it embodies are
# proprietary to Starburst, are protected by trade secret and copyright law,
# and may be covered by patents in the U.S. and abroad.  Distribution,
# reproduction, and relicensing are strictly forbidden without Starburst's prior
# written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED.  THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
# AND NONINFRINGEMENT ARE EXPRESSLY DISCLAIMED. IN NO EVENT SHALL STARBURST BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR ITS USE
# EVEN IF STARBURST HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Please refer to your agreement(s) with Starburst for further information.
################################################################################

set -xeuo pipefail

test -v HIVE_METASTORE_JDBC_URL
test -v HIVE_METASTORE_DRIVER
test -v HIVE_METASTORE_USER
test -v HIVE_METASTORE_PASSWORD

sed -i \
  -e "s|%HIVE_METASTORE_JDBC_URL%|${HIVE_METASTORE_JDBC_URL}|g" \
  -e "s|%HIVE_METASTORE_DRIVER%|${HIVE_METASTORE_DRIVER}|g" \
  -e "s|%HIVE_METASTORE_USER%|${HIVE_METASTORE_USER}|g" \
  -e "s|%HIVE_METASTORE_PASSWORD%|${HIVE_METASTORE_PASSWORD}|g" \
  -e "s|%S3_ENDPOINT%|${S3_ENDPOINT:-}|g" \
  -e "s|%S3_ACCESS_KEY%|${S3_ACCESS_KEY:-}|g" \
  -e "s|%S3_SECRET_KEY%|${S3_SECRET_KEY:-}|g" \
  -e "s|%S3_PATH_STYLE_ACCESS%|${S3_PATH_STYLE_ACCESS:-false}|g" \
  -e "s|%REGION%|${REGION:-}|g" \
  /etc/hive/conf/hive-site.xml

export HIVE_METASTORE_DB_HOST="$(echo "$HIVE_METASTORE_JDBC_URL" | cut -d / -f 3 | cut -d : -f 1)"
export HIVE_METASTORE_DB_NAME="$(echo "$HIVE_METASTORE_JDBC_URL" | cut -d / -f 4)"
if [[ "$HIVE_METASTORE_DRIVER" == com.mysql.jdbc.Driver ]]; then
    sqlDir=/opt/sql/mysql
    function sql() {
        mysql --host="$HIVE_METASTORE_DB_HOST" --user="$HIVE_METASTORE_USER" --password="$HIVE_METASTORE_PASSWORD" "$HIVE_METASTORE_DB_NAME" "$@"
    }
    # Make sure that postgres is accessible
    sql -e 'SELECT 1'

    if ! sql -e 'SELECT 1 FROM DBS LIMIT 1'; then
        find /opt/sql/mysql -type f | sort -n | while read sqlFile; do
            cat "$sqlFile" | sql
        done
    fi
elif [[ "$HIVE_METASTORE_DRIVER" == org.postgresql.Driver ]]; then
    function sql() {
        export PGPASSWORD="$HIVE_METASTORE_PASSWORD"
        psql --host="$HIVE_METASTORE_DB_HOST" --username="$HIVE_METASTORE_USER" "$HIVE_METASTORE_DB_NAME" "$@"
    }

    # Make sure that postgres is accessible
    sql -c 'SELECT 1'

    if ! sql -c 'SELECT 1 FROM "DBS" LIMIT 1'; then
        find /opt/sql/postgres -type f | sort -n | while read sqlFile; do
            sql -f "$sqlFile"
        done
    fi
else
    echo "Unsupported driver: $$HIVE_METASTORE_DRIVER" >&2
    exit 1
fi

# log threshold is set to INFO to avoid log pollution from Datanucleus
exec hive --service metastore --hiveconf hive.root.logger=INFO,console --hiveconf hive.log.threshold=INFO
