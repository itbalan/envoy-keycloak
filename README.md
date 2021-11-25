Envoy integration with Open Policy Agent (OPA)

Pre-requisites
--------------
1. Docker Engine installed and running
2. Docker Compose installed
3. Build service-template spring boot application and copy the jar file from ./target folder to the folder envoy-opa
4. Build service-template-greeting spring boot application and copy the jar file from ./target folder to the folder envoy-opa

Follow the steps below to build the images and run the containers
-----------------------------------------------------------------
1. Open command prompt and go to the directory envoy-opa

2. Run the command to build envoy front-proxy, service-template and service-template-greeting images: docker-compose build --pull

3. Run the command to deploy envoy front proxy, OPA, service-template and service-template-greeting containers:: docker-compose up -d

4. Run the command to check the containers running (you should see 4 containers running): docker-compose ps

5. Run the command to check the log: docker logs -f {container name or process id}

# Curl commands to test 'greeting' service
Case 1: GET is accessible to both partner1 and partner2 <br>
curl --location --request GET 'http://localhost:8080/test/greeting?name=<any name>' \
--header 'from: partner1'

Result: you should see the name printed in the result
  
Note: 
1. Change the header 'from' value to 'partner2' - you should see the name printed in the result
2. Change the header 'from' value to anything other than 'partner1 or partner2' or remove the 'from' header itself - you should recieve 403 - Forbidden

Case 2: POST is accessible to only partner1 <br>
curl --location --request POST 'http://localhost:8080/test/greeting?name=<any name>' \
--header 'from: partner2'

Result: you should see the name printed in the result

Note: Change the header 'from' value to anything other than 'partner2' or remove the 'from' header itself - you should recieve 403 - Forbidden

# Curl commands to test 'template' service
Case 1: This service open for anybody to access <br>
curl --location --request GET 'http://localhost:8080/template/'

Result: you should see the result with the message printed

# Curl commands to test 'ratelimits'
1. Greeting service with 'from' header with 'partner1' value is limited for 3 requests per minute - 4th request will receive 429 http status
curl --location --request GET 'http://localhost:8082/test/greeting?name=bala' --header 'from: partner1'
2. Greeting service with 'from' header with 'partner2' value is limited for 2 requests per second - 3rd request will receive 429 http status
curl --location --request GET 'http://localhost:8082/test/greeting?name=bala' --header 'from: partner2'
3. Template service with 'from' header with 'partner3' value is unlimited 
curl --location --request GET 'http://localhost:8082/template/' --header 'from:  partner3'
4. Template service with 'from' header with any value other than 'partner3' value is limited to 2 requests per minute - 3rd request will receive 429 http status.
curl --location --request GET 'http://localhost:8082/template/' --header 'from:  '
"# envoy-keycloak" 
"# envoy-keycloak" 
