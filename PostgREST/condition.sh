#!/bin/bash
id=61673
type="UNIC"
desc="CTAF"
freq=125.4
echo  "\n"
GET 127.0.0.1:3000/airport_fr?id=gte.$id\&type=eq.$type
echo  "\n"
GET 127.0.0.1:3000/airport_fr?description=eq.$desc\&id=lte.$id
echo "\n"
GET 127.0.0.1:3000/airport_fr?frequency_mhz=lte.$freq\&airport_ref=eq.67
