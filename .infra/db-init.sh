#!/bin/bash
echo 'Create replica set keyfile'
openssl rand -base64 756 > /data/configdb/mongo-keyfile
chmod 400 /data/configdb/mongo-keyfile
echo 'Replica set keyfile created'

mongosh -- "${MONGO_INITDB_DATABASE}" <<EOF
disableTelemetry();
db.auth('$MONGO_INITDB_ROOT_USERNAME', '$MONGO_INITDB_ROOT_PASSWORD');
var db = db.getSiblingDB('$MONGO_DATABASE');
db.createUser(
    {
        user: '$MONGO_USERNAME',
        pwd: '$MONGO_PASSWORD',
        roles: [{role: 'readWrite', db: '$MONGO_DATABASE'}]
    }
);
print('Db user created');
EOF
