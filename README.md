# Cloud Resume Challenge

This is a learning repository for performing the Cloud Resume Challenge as outlined below:
- https://cloudresumechallenge.dev/

This challenge will utilize Terraform to provision the challenge in GCP. The deployment steps are as follows:
1. Setup GCP CLI authentication
   1. ```gcloud auth application-default login```
   2. ```gcloud config set project PROJECT_ID```
2. Initialize terraform
   1. ```cd terraform-gcp/```
   2. ```terraform init```
   3. ```terraform plan```
3. Deploy
   1. ```terraform apply```

Requirements:
- GCP account
- Terraform
  
# Checklist
- [x] Obtain the Google Cloud Digital Leader certification (or higher)
- [x] Write your resume in HTML
- [x] Style your resume with CSS
- [ ] Deploy your HTML resume as a static website using Google Cloud Storage
- [ ] Enable HTTPS using a Cloud Load Balancer and Cloud CDN
- [ ] Point a custom DNS domain to your load balancer endpoint
- [ ] Add a Javascript visitor counter to your resume webpage
- [ ] Store and update the visitor count in Google Cloud Firestore
- [ ] Create an API (e.g., with Google Cloud Functions) to interact with Firestore
- [ ] Write the serverless function in Python using Google Cloud Client Libraries
- [ ] Include tests for your Python code
- [ ] Define infrastructure using Terraform (Infrastructure as Code)
- [ ] Use GitHub for source control of backend code
- [ ] Set up CI/CD for backend with Cloud Build (run tests, deploy on success)
- [ ] Use a separate GitHub repo for website code and set up CI/CD for frontend
- [ ] Write and link a short blog post about your project learnings
