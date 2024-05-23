# mediawiki deployment

## Overview

This repository contains the setup and deployment instructions for a MediaWiki application using Docker, GitHub Actions, and Helm. The deployment includes creating a Docker image from scratch, building and pushing the image using GitHub Actions, and deploying the application using a custom Helm chart.

## Steps

### 1. Dockerfile Creation

- A `Dockerfile` has been created from scratch using Ubuntu as the base image.
- Installed required tools for MediaWiki including Apache, MySQL, and PHP.
- Configured MySQL commands within the `Dockerfile` to create a MySQL database, and set up a username and password for MediaWiki.

### 2. GitHub Actions Workflow

- A GitHub Actions workflow is set up to build the Docker image and push it to a personal Docker Hub account.
- The workflow triggers automatically whenever new commits are pushed to the main branch.
- Secrets such as MySQL password, Docker Hub username, and password have been configured as repository and environment secrets.

### 3. Custom Helm Chart

- A custom Helm chart is created to deploy the MediaWiki application.
- The Helm chart is configured with a LoadBalancer IP to expose the MediaWiki app to the internet. Note that this is for assignment purposes; the recommended way is to configure DNS through an ingress service.
- The `values.yaml` file includes options for two deployment strategies: rolling update and blue-green deployment. Users can choose the appropriate strategy based on their requirements.

### 4. Testing and Continuous Deployment

- The MediaWiki application has been tested using a personal Azure Kubernetes Service (AKS) cluster.
- Continuous Deployment (CD) has not been implemented in this repository. If needed, a CD step can be added to this project.

## Notes

- The use of a LoadBalancer to expose the application to the internet is not recommended for production environments. Instead, configuring DNS through an ingress service is the preferred approach.
- This setup is intended for educational and assignment purposes and may not reflect best practices for deploying applications in a production environment.

## Future Improvements

- Implementing a Continuous Deployment (CD) pipeline.
- Enhancing security and scalability for production readiness.
- Using ingress controllers for better traffic management and SSL termination.

## Conclusion

This repository demonstrates the deployment of a MediaWiki application using a custom Docker image, GitHub Actions for CI, and Helm for Kubernetes deployment. While the setup is simplified for assignment purposes, it provides a foundation for more complex and robust deployment scenarios.
