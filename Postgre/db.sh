#!/bin/sh
DATABASE=docker
USERNAME=docker
HOSTNAME=172.17.0.2
export PGPASSWORD=docker

psql -h $HOSTNAME -U $USERNAME $DATABaSE << EOF
CREATE TABLE airport_freq(
  id    integer,
  airport_ref integer,
  airport_ident integer,
  type varchar,
  description varchar,
  frequency_mhz varchar,
);
copy airport_freq(id,airport_ref,airport_ident,type,description,frequency_mhz) FROM '/home/airport-frequencies.csv' DELIMITER ',' CSV HEADER;
EOF

