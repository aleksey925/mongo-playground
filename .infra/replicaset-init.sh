#!/bin/bash
mongosh "mongodb://${ROOT_USER}:${ROOT_PASS}@${HOSTNAME}:27017/${ROOT_DB}" <<EOF
while (true) {
    const status = db.serverStatus();
    if (status['ok'] === 1) {
        try {
            let _ = rs.status();
            print('Replicaset has already been initialized');
        } catch (err) {
            rs.initiate(
                {_id: 'rs0', members: [{_id: 0, host: 'host.docker.internal:27017'}]}
            )
            print('Replicaset is initialized');
        }
        break;
    } else {
        print('Waiting for the database to start...');
        sleep(1000);
    }
}
EOF
