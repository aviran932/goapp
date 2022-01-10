# y2_devops_test

Create a branch with your name and follow these tasks:

### Task 1 - Dockerize
Create a `Dockerfile` for this simple go web application.

### Task 2 - Kubernetes Integration
Create all of the neccessry objects in order to run the application in a working kubernetes cluster.

### Task 3 - Create a simple CI/CD script
Edit `.github/actions/pipeline/entrypoint.sh` with the following steps:
* build docker image
* tag the new image as `<branch_name>-<sha>`
* optional - test the image before pushing (only `/posts` on GET)
* push
* deploy

TIPs:
* the script will run after each commit
* build is running on a fresh ubuntu image so docker must be installed
* you can check it in `Actions` tab..
