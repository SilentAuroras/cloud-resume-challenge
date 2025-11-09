import functions_framework
from flask import jsonify
from google.cloud import firestore

# Setup firestore client
db = firestore.Client()

# Setup entry point for the Cloud Function
@functions_framework.http
def entry_point(request):

    # Grab Json request
    data = request.get_json()

    # Check for visitor count in the request
    if not data or 'visitor_count' not in data:
        return jsonify({'error': 'Missing visitor_count'}), 400

    # Update the Firestore database
    count = data['visitor_count']

    # Increase count
    count = count + 1

    # Update firestore
    doc_ref = db.collection('visitor_counts').document()
    doc_ref.set({'count': count})

    # Return success response
    return jsonify({'status': 'success', 'count': count}), 200