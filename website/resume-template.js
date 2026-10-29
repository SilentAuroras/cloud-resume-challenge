// Sent a request to the GCP Cloud Function to increase visitor count
// Update the URL with terraform to point towards cloud function URL
async function visitorCount() {

	// Cloud Function URL
	const function_url = "${cloud_function_url}";

	// Handle function
	try {
        // Just send GET, have function pull and update database
		const response = await fetch(function_url, { method: "GET" });

		// Check for response
		if (!response.ok) {
			throw new Error("Failed to fetch function");
		}

		// No error, update count
		document.getElementById("visitor-count").textContent = response.count;
	}
	
	catch (error) {
		// Catch cloud function error
		console.error("Error updating visitor count: ", error);
		document.getElementById(("visitor-count".textContent = "n/a"));
	}
}

// Run function on page load
document.addEventListener("DOMContentLoaded", function() {
  visitorCount();
});
