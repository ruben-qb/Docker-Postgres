#!/bin/sh
DATABASE=docker
USERNAME=docker
HOSTNAME=127.0.0.1
export PGPASSWORD=docker

psql -h $HOSTNAME -U $USERNAME $DATABaSE << EOF
CREATE TABLE airport_frequency(
  id    integer,
  airport_ref integer,
  airport_ident varchar,
  type varchar,
  description varchar,
  frequency_mhz varchar
);
copy airport_frequency(id,airport_ref,airport_ident,type,description,frequency_mhz) FROM '/home/airport-frequencies.csv' DELIMITER ',' CSV HEADER;
EOF

