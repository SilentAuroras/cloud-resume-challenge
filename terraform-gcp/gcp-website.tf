// Create random id for storage bucket
resource "random_id" "bucket-prefix" {
    byte_length = 8
}

// Bucket suffix name - set in tfvars
variable "bucket_suffix" {
    type = string
}

// TLS domain - set in tfvars
variable "domain" {
  type = string
}

// TLS Cert
resource "google_compute_managed_ssl_certificate" "tls_cert" {
  name = "tls-cert-url-map"
  managed {
    domains = [
      "www.resume.${var.domain}"
    ]
  }
}

// Create static bucket for website
resource "google_storage_bucket" "static-site" {
    name = "${random_id.bucket-prefix.hex}-${var.bucket_suffix}"

    location = "US"
    force_destroy = true

    uniform_bucket_level_access = true

    website {
        main_page_suffix = "resume.html"
        not_found_page = "404.html"
    }

    cors {
        origin = ["*"]
        method = ["GET", "HEAD", "POST", "DELETE"]
        response_header = ["*"]
        max_age_seconds = 3600
    }
}

// Allow public access to the bucket
resource "google_storage_bucket_iam_member" "all_users" {
    bucket   = google_storage_bucket.static-site.name
    member   = "allUsers"
    role     = "roles/storage.legacyObjectReader"
}

// Upload resume.html to storage bucket
resource "google_storage_bucket_object" "html_obj" {
    name = "resume.html"
    source = "../website/resume.html"
    content_type = "text/html"
    bucket = google_storage_bucket.static-site.id
}

// Upload resume.css to storage bucket
resource "google_storage_bucket_object" "css_obj" {
    name = "resume.css"
    source = "../website/resume.css"
    content_type = "text/css"
    bucket = google_storage_bucket.static-site.id
}

// Update the JavaScript to call the CloudFunction
resource "local_file" "js_updated" {
  content = templatefile("../website/resume-template.js", {
    cloud_function_url = google_cloudfunctions2_function.py-to-firestore.service_config[0].uri
  })
  filename = "../website/resume.js"
  depends_on = [google_cloudfunctions2_function.py-to-firestore]
}

// Upload resume.js to storage bucket
resource "google_storage_bucket_object" "js_obj" {
    name = "resume.js"
    source = "../website/resume.js"
    content_type = "application/javascript"
    bucket = google_storage_bucket.static-site.id
    depends_on = [ local_file.js_updated ]
}

// Print out website URL
output "website_url" {
  value = google_storage_bucket_object.html_obj.name
}