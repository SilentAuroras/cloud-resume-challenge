// Create random id for storage bucket
resource "random_id" "bucket-prefix" {
    byte_length = 8
}

// Bucket suffix name - set in tfvars
variable "bucket_suffix" {
    type = string
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
        origin = [""]
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
    content_type = "text/plain"
    bucket = google_storage_bucket.static-site.id
}

// Upload resume.css to storage bucket
resource "google_storage_bucket_object" "js_obj" {
    name = "resume.js"
    source = "../website/resume.js"
    content_type = "text/plain"
    bucket = google_storage_bucket.static-site.id
}