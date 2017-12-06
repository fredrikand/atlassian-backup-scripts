#!/bin/bash -xe

function cleanup
{
        set +e
        umount /mnt/backup
        lvremove -y /dev/lvm/backup
}

trap cleanup 'EXIT'

BACKUP_DIR='/mnt/bitbucket-backups'
mkdir -p ${BACKUP_DIR}

TIMESTAMP=$(date +'%Y-%m-%d-%H-%M')

# Database
DB_NAME='bitbucket'
DB_HOST='se-bitb-stg'
DB_USER='bitbucketuser'
DB_PASS='jellyfish'

touch ~/.pgpass
if ! grep -q "${DB_HOST}:5432:${DB_NAME}:${DB_USER}:${DB_PASS}" ~/.pgpass ; then
    echo "${DB_HOST}:5432:${DB_NAME}:${DB_USER}:${DB_PASS}" >> ~/.pgpass
fi
chmod 600 ~/.pgpass

HOME_BACKUP_OUTPUT="${BACKUP_DIR}/bitbucket-shared-home-${TIMESTAMP}.tar"
DATABASE_DUMP_OUTPUT="${BACKUP_DIR}/bitbucket-database-dump-${TIMESTAMP}.sql"


##
##
## lock Bitbucket ??
##
##
lvcreate -L2G -s -n backup /dev/lvm/bitbucket-disk
/usr/bin/pg_dump -U "${DB_USER}" -d "${DB_NAME}" -h "${DB_HOST}" -w > "${DATABASE_DUMP_OUTPUT}"

mkdir -p /mnt/backup
mount /dev/lvm/backup /mnt/backup/ -onouuid,ro

echo "## Do the copy stuff from disk"

tar -C /mnt/backup -cf ${HOME_BACKUP_OUTPUT} bbdiskshare
# Saves 1-2 GB out of 24GB. Perhaps not worth the time
#pigz ${HOME_BACKUP_OUTPUT}

cleanup



