# Docker-Postgres
-----------------------------------------------Docker-Postgres-------------------------------------------------------------

We are using 5432 port as default port for PostgreSQL 9.5.3 and 3000 as port for PostgREST container.Confirm if both 3000 port and 5432 are not used using TELNET command . If it uses any port bind our container to a different port.


# Build and Run the PostgREST 0.3.2 container 

Go to the PostgREST directory using command 
  
  cd PostgREST 

Build the docker container from this directory using the Dockerfile , You can use any name tag instead of ruben_qb/pgrest 
  
  sudo docker build -t ruben_qb/pgrest .

Run the docker container using the command assuming you have used the nametag as i did

  sudo docker run --name docker_postgrest -itd -p 127.0.0.1:3000:3000 ruben_qb/pgrest
  
---------------------------------------------------------------------------------------------------------------------------

# Build and Run the PostgreSQL 9.5 container  
 
Shift the current directory to Postgre using the command

   cd Postgre

Build the docker container for PostgreSQL database from this directory using the docker file using the command

   sudo docker build -t ruben_qb/pgsql .

Run the docker container for Postgres using the command

   sudo docker run --name intermediate -itd ruben_qb/pgsql

Now we need to create an link between the containers so that REST api communicates with the PostgreSQL db using the command

   sudo docker run -itd --name docker_pgsql  -p 127.0.0.1:5432:5432 --link intermediate:docker_postgrest ruben_qb/pgsql

To confirm if all our docker containers are running you can use

   sudo docker ps 

---------------------------------------------------------------------------------------------------------------------------

# Script to add 1000 records to a table in the database  

It is not reccomended to keep the port 5432 connected to DB open to network , here we have opened it just for the testing purpose and making it easier .

Get into the execute shell of Docker container pgsql by using the following commands 
   
   sudo docker ps

Select container id of first (latest) docker file with name docker_pgsql
 
   sudo docker exec -it 296c7716cd35 /bin/bash
   cd /home
   sh db.sh
   exit

---------------------------------------------------------------------------------------------------------------------------

# Script to filter sql queries based on conditions 

Change your directory to PostgREST and execute the bash script condition.sh using command
    
   sh condition.sh
   
---------------------------------------------------------------------------------------------------------------------------

# Benchmark tests for REST requests using AB 

I have used Apache Benchmark testing for testing the performance of the REST requests. I have taken a set of benchmark based on multiple conditions and below is the output of the tests with header corresponding to each test done on it

[ AB test for table listing with 1000 requests and 100 concurrent requests at a time ]

test@HP:~$ ab -n 1000 -c 100 http://127.0.0.1:3000/

Document Path:          /
Document Length:        66 bytes

Concurrency Level:      100
Time taken for tests:   0.988 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      196000 bytes
HTML transferred:       66000 bytes
Requests per second:    1012.13 [#/sec] (mean)
Time per request:       98.802 [ms] (mean)
Time per request:       0.988 [ms] (mean, across all concurrent requests)
Transfer rate:          193.73 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.5      0       3
Processing:    10   98  76.9     76     397
Waiting:        9   98  77.0     76     397
Total:         10   98  77.2     76     398

Percentage of the requests served within a certain time (ms)
  50%     76
  66%     83
  75%     93
  80%    109
  90%    170
  95%    314
  98%    353
  99%    378
 100%    398 (longest request)


[ AB test for listing all rows in a table (28000 rows) with 1000 requests and 100 concurrent requests at a time ]

test@HP:~$ ab -n 1000 -c 100 http://127.0.0.1:3000/airport_frequency

Document Path:          /airport_frequency
Document Length:        3364030 bytes

Concurrency Level:      100
Time taken for tests:   75.264 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      3364228000 bytes
HTML transferred:       3364030000 bytes
Requests per second:    13.29 [#/sec] (mean)
Time per request:       7526.359 [ms] (mean)
Time per request:       75.264 [ms] (mean, across all concurrent requests)
Transfer rate:          43651.64 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.9      0       7
Processing:   452 7404 1035.3   7443   10020
Waiting:      447 7391 1034.1   7432   10011
Total:        452 7404 1035.3   7444   10020

Percentage of the requests served within a certain time (ms)
  50%   7444
  66%   7714
  75%   7914
  80%   8072
  90%   8462
  95%   9142
  98%   9479
  99%   9727
 100%  10020 (longest request)

[ AB test for listing rows based on a single condition in a table ) with 1000 requests and 100 concurrent requests at a time ]

Document Path:          /airport_frequency?id=gte.65868
Document Length:        1288088 bytes

Concurrency Level:      100
Time taken for tests:   33.921 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      1288299000 bytes
HTML transferred:       1288088000 bytes
Requests per second:    29.48 [#/sec] (mean)
Time per request:       3392.126 [ms] (mean)
Time per request:       33.921 [ms] (mean, across all concurrent requests)
Transfer rate:          37088.97 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.6      0       3
Processing:   376 3316 791.3   3410    5092
Waiting:      374 3305 789.3   3390    5090
Total:        376 3316 791.4   3410    5092

Percentage of the requests served within a certain time (ms)
  50%   3410
  66%   3788
  75%   3940
  80%   4024
  90%   4240
  95%   4348
  98%   4436
  99%   4499
 100%   5092 (longest request)


Document Path:          /airport_frequency?id=gte.65868
Document Length:        1288088 bytes

Concurrency Level:      100
Time taken for tests:   34.451 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      1288299000 bytes
HTML transferred:       1288088000 bytes
Requests per second:    29.03 [#/sec] (mean)
Time per request:       3445.096 [ms] (mean)
Time per request:       34.451 [ms] (mean, across all concurrent requests)
Transfer rate:          36518.71 [Kbytes/sec] received

[ AB test for listing rows based on a multiple conditions in a table with 1000 requests and 100 concurrent requests at a time ]

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.7      0       4
Processing:  1365 3381 605.2   3427    4566
Waiting:     1360 3374 604.7   3423    4562
Total:       1365 3382 605.4   3427    4567

Percentage of the requests served within a certain time (ms)
  50%   3427
  66%   3650
  75%   3780
  80%   3874
  90%   4180
  95%   4338
  98%   4474
  99%   4512
 100%   4567 (longest request)



