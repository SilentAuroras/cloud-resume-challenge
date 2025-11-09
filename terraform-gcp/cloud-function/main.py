import functions_framework
from flask import jsonify
from google.cloud import firestore

# Setup firestore client
db = firestore.Client()

# Setup entry point for the Cloud Function
@functions_framework.http
def entry_point(request):
    try:
        # Reference to a single document to store the counter
        doc_ref = db.collection("count").document("visitor_count_doc")

        # Atomically increment the count by 1
        doc_ref.set({"count": firestore.Increment(1)}, merge=True)

        # Optionally read back the updated value
        doc = doc_ref.get()
        new_count = doc.get("count", 0)

        return jsonify({"status": "success", "count": new_count}), 200

    except Exception as e:
        print(f"Error updating count: {e}")
        return jsonify({"status": "error", "message": "error"}), 500