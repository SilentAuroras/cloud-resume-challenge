# Cloud Resume Challenge

This is a learning repository for performing the Cloud Resume Challenge as outlined below. The checklist below follows the website's list.
- https://cloudresumechallenge.dev/

This challenge will use Terraform to provision the infrastructure in GCP. The deployment steps are as follows:
1. Setup GCP CLI authentication
   1. ```gcloud auth application-default login```
   2. ```gcloud config set project PROJECT_ID```
2. Create a terraform.tfvars file with the following variables set:
```
   project_name = ""
   region = ""
   bucket_suffix = ""
```
3. Initialize terraform
   1. ```cd terraform-gcp/```
   2. ```terraform init```
   3. ```terraform plan```
3. Deploy
   1. ```terraform apply```

Requirements:
- GCP account
- Terraform
  
# Checklist
- [x] Get the Google Cloud Digital Leader certification (or higher)
  - Associate Cloud Engineer obtained
- [x] Write your resume in HTML
- [x] Style your resume with CSS
- [x] Deploy your HTML resume as a static website using Google Cloud Storage
- [x] Enable HTTPS using a Cloud Load Balancer and Cloud CDN
  - Not buying a domain, so just using HTTP
  - Instead, setting up cloud load balancer with direct IP + HTTP
- [x] Point a custom DNS domain to your load balancer endpoint
  - Not buying a domain
- [ ] Add a JavaScript visitor counter to your resume webpage
- [x] Store and update the visitor count in Google Cloud Firestore
- [ ] Create an API (e.g., with Google Cloud Functions) to interact with Firestore
- [ ] Write the serverless function in Python using Google Cloud Client Libraries
- [ ] Include tests for your Python code
- [x] Define infrastructure using Terraform (Infrastructure as Code)
- [ ] Use GitHub for source control of backend code
- [ ] Set up CI/CD for backend with Cloud Build (run tests, deploy on success)
- [ ] Use a separate GitHub repo for website code and set up CI/CD for frontend
- [ ] Write and link a short blog post about your project learnings
  - Adding screenshots and documentation here
