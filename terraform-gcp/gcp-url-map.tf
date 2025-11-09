// Get the public IP for the load balancer
resource "google_compute_global_address" "static_ip" {
	name = "static-ip"
}

// Output the static ip for the https proxy
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

// HTTPS proxy setup and link to url map
resource "google_compute_target_https_proxy" "https_proxy" {
	name    = "https-proxy"
	url_map = google_compute_url_map.url_map.self_link
    ssl_certificates = [google_compute_managed_ssl_certificate.tls_cert.id]
}

// Forwarding rule to allow 443
resource "google_compute_global_forwarding_rule" "forwarding_rule" {
	name = "https-forwarding"
  	target = google_compute_target_https_proxy.https_proxy.self_link
  	ip_address = google_compute_global_address.static_ip.address
  	ip_protocol = "TCP"
  	port_range = "443"
}

// DNS zone
resource "google_dns_managed_zone" "proxy_dns_zone" {
  name     = "proxy-dns-zone"
  dns_name = "${var.domain}."
}

// DNS Record
resource "google_dns_record_set" "www" {
  name = "www.resume.${var.domain}."
  managed_zone = google_dns_managed_zone.proxy_dns_zone.name
  type         = "A"
  ttl           = 300
  rrdatas = [google_compute_global_address.static_ip.address]
  depends_on = [google_dns_managed_zone.proxy_dns_zone]
}

// Output URL with domain for resume
output "resume_url" {
  value = "https://www.resume.${var.domain}/resume.html"
}