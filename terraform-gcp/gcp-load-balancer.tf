// Get the public IP for the load balancer
resource "google_compute_global_address" "static_ip" {
	name = "static-ip"
}

// Output the static ip for the http proxy
output "proxy_static_ip" {
	value = google_compute_global_address.static_ip.address
}

// Setup bucket as backend
resource "google_compute_backend_bucket" "cdn_backend_bucket" {
	bucket_name = google_storage_bucket.static-site.name
	name        = "backend-bucket"
	enable_cdn  = true
}

// URL map to bucket
resource "google_compute_url_map" "url_map" {
	name        = "cdn-url-map"
	default_service  = google_compute_backend_bucket.cdn_backend_bucket.id
}

// HTTP proxy setup and link to url map
resource "google_compute_target_http_proxy" "http_proxy" {
	name    = "http-proxy"
	url_map = google_compute_url_map.url_map.self_link
}

// Forwarding rule to allow 80
resource "google_compute_global_forwarding_rule" "forwarding_rule" {
	name = "http-forwarding"
  	target = google_compute_target_http_proxy.http_proxy.self_link
  	ip_address = google_compute_global_address.static_ip.address
  	ip_protocol = "TCP"
  	port_range = "80"
}