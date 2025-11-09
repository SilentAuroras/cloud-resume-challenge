// Firestore database
resource "google_firestore_database" "resume-firestore" {
	name            = "resume-firestore-${random_id.bucket-prefix.hex}"
	project         = var.project_name
	location_id     = var.region
	type            = "FIRESTORE_NATIVE"
	depends_on = [ google_storage_bucket.cloud-function-bucket ]
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

// Cloud function creation - use cloudfunctions v2
resource "google_cloudfunctions2_function" "py-to-firestore" {
	name     = "py-to-firestore"
	project  = var.project_name
	location = var.region
	build_config {
		runtime     = "python310"
		entry_point = "entry_point"
		source {
			storage_source {
				bucket = google_storage_bucket.cloud-function-bucket.name
				object = google_storage_bucket_object.archive.name
			}
		}
	}
	service_config {
		available_memory = "256M"
		timeout_seconds  = 60
		ingress_settings = "ALLOW_ALL"
	}
}

// IAM permissions to allow public to run the function
resource "google_cloudfunctions2_function_iam_member" "public_invoke" {
	project       = var.project_name
    location      = var.region
	cloud_function = google_cloudfunctions2_function.py-to-firestore.name
	role          = "roles/cloudfunctions.invoker"
	member        = "allUsers" // Public endpoint
	depends_on = [ google_cloudfunctions2_function.py-to-firestore ]
}