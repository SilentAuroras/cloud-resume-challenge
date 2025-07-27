// Firestore database
resource "google_firestore_database" "resume-firestore" {
	name            = "resume-firestore"
	project         = var.project_name
	location_id     = var.region
	type            = "FIRESTORE_NATIVE"
	deletion_policy = "DELETE"
}

// Storage bucket for cloud function code
resource "google_storage_bucket" "cloud-function-bucket" {
	name          = "${random_id.bucket-prefix.hex}-cloud-function-bucket"
	location      = "US"
	force_destroy = true
}

// Zip up the cloud function directory
data "archive_file" "cloud-function-zip" {
	type        = "zip"
	source_dir  = "./cloud-function"
	output_path = "./cloud-function.zip"
}

// Upload the cloud function zip to the bucket
resource "google_storage_bucket_object" "archive" {
	name   = "cloud-function.zip"
	bucket = google_storage_bucket.cloud-function-bucket.name
	source = "./cloud-function.zip"
}

// Cloud function creation
resource "google_cloudfunctions_function" "py-to-firestore" {
	name                  = "py-to-firestore"
	project               = var.project_name
	region                = var.region
	description           = "API to connect visitor counter to Firestore"
	runtime               = "python310"
	available_memory_mb   = 128
	source_archive_bucket = google_storage_bucket.cloud-function-bucket.name
	source_archive_object = google_storage_bucket_object.archive.name
	entry_point           = "entry_point"
	trigger_http          = true
}

// IAM permissions to allow public to run the function
resource "google_cloudfunctions_function_iam_member" "public_invoke" {
	project       = var.project_name
	region        = var.region
	cloud_function = google_cloudfunctions_function.py-to-firestore.name
	role          = "roles/cloudfunctions.invoker"
	member        = "allUsers" // Public endpoint
}