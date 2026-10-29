import functions_framework
from flask import jsonify, make_response
from google.cloud import firestore

# Setup firestore client
db = firestore.Client()

# Setup entry point for the Cloud Function
@functions_framework.http
def entry_point(request):
    try:
        # Read the current count
        doc_ref = db.collection("count").document("visitor_count_doc")

        # Increment the count by 1
        doc_ref.set({"count": firestore.Increment(1)}, merge=True)

        # Read back the updated value
        doc = doc_ref.get()
        count = (doc.to_dict() or {}).get("count", 0)

        # Return json response with count
        response = jsonify({"status": "success", "count": count})

    # Catch
    except Exception:
        response = jsonify({"status": "error", "message": "Internal server error"})
        response.status_code = 500

    # CORS
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Methods"] = "GET, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"

    # Return json response
    return response