<div align="left">
  <h3>NodeJS Sample Application</h3>
  <strong>
      In this project I demonstrated how to deploy a microservice application in EKS Cluster. Here I have used various devops tools like Jenkins for task automation, terraform for infrastructure provisioning, sonarqube for code analysis, ECR as container registry etc.
  </strong>
</div>
<br>

# Run the application on local development environment
```
cd nodejs-app-ec2
npm install
npm start
```
<br>

# Production Deployment
Production deployement starts after devloper pushes code to github to a specific branch. 

## Create a CI/CD pipeline in Jenkins for production deployment
Jenkins pipeline do the all the taks required from code build to production deployment in EKS Cluster. Jenkins pipeline do the following tasks.
- Code Build
- Code Test
- Code Analysis
- Build docker image
- Push image to ECR
- Deploy application to EKS cluster

<br>

## Tools Used in Production Deployment
1. Cloud plaftform AWS
2. Git
3. Terraform
4. Helm
5. Docker
6. Jenkins
7. SonarQube
8. Elastic Kubernetes Service(EKS)
9. Elastic Container Registry(ECR)
10. Elastice Block Storage(EBS)
11. Nginx Ingress Controller
12. Ingress resources
13. External DNS
14. Cert Manager
15. Cluster AutoScaler
16. Application LoabBalancer
17. Route53
18. Prometheus and Grafana
19. Slack Notification






