## To push you containers to the registry
````
docker login code.monsoonconsulting.com:4567
docker build -t code.monsoonconsulting.com:4567/docker/ci-runner-aws-terraform .
docker push code.monsoonconsulting.com:4567/docker/ci-runner-aws-terraform
````
