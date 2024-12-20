#
#   server.py
#   Buzzing
#
#   Created by Erick Cifuentes on 12/01/2024.
#
from flask import Flask, request, jsonify
from flask_cors import CORS
from supabase import create_client, Client
from datetime import datetime

# Flask app setup
app = Flask(__name__)
CORS(app)

# Supabase client setup
SUPABASE_URL = "https://utraejrmcdvwvjzcuogr.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV0cmFlanJtY2R2d3ZqemN1b2dyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1ODI4MzQsImV4cCI6MjA0NzE1ODgzNH0.EgR3tTwWrpsvpwRcLoFX5t1sOrPEMTIh64Udfs27YwY"

# Create Supabase client
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)


@app.route("/", methods=["GET"])
def server_check():
    return jsonify({"status": "Server is running!"})


# AKA: Add User to DB
@app.route("/register", methods=["POST"])
def register_user():
    try:
        # Parse the incoming JSON payload
        data = request.json
        username = data.get("username")
        password = data.get("password")
        name = data.get("name", None)
        email = data.get("email", None)
        profile_picture = data.get("profile_picture", None)

        # Validate required fields
        if not username or not password:
            return jsonify({"error": "Username and password are required"}), 400

        # Insert user into the database
        response = supabase.table("users").insert({
            "username": username,
            "password": password,
            "name": name,
            "email": email,
            "profile_picture": profile_picture,
        }).execute()

        # Handle Supabase response
        if response.error:
            return jsonify({"error": response.error.message}), 400

        # Success
        return jsonify({
            "message": "User registered successfully",
            "user": response.data
        }), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# No security measures in place
@app.route("/login", methods=["POST"])
def login_user():
    try:
        # Parse the incoming JSON payload
        data = request.json
        email = data.get("email")
        password = data.get("password")

        # Validate input
        if not email or not password:
            return jsonify({"error": "Email and password are required"}), 400

        # Normalize email to lowercase
        email = email.lower()

        # Query the database for user details (password, username, and profile picture) using the given email
        response = supabase.table("users").select("password, username, email, profile_picture").eq("email",
                                                                                                   email).execute()

        # Check if the user exists
        if response.data is None or len(response.data) == 0:
            return jsonify({"error": "Invalid email or password"}), 400

        # Retrieve stored password
        stored_password = response.data[0]["password"]

        # Compare passwords (plaintext comparison for demo purposes)
        if password != stored_password:
            return jsonify({"error": "Invalid email or password"}), 400

        # Retrieve additional user details
        username = response.data[0]["username"]
        profile_picture = response.data[0]["profile_picture"]

        # If successful, return user details and a success message
        return jsonify({
            "message": "Login successful",
            "username": username,
            "email": email,
            "password": stored_password,
            "profile_picture": profile_picture
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# Add user review to DB
@app.route("/submit-review", methods=["POST"])
def submit_review():
    try:
        # Parse incoming JSON
        data = request.json
        print(data)
        username = data.get("username")
        bar_name = data.get("bar_name")
        publish_time = datetime.utcnow().isoformat(timespec='seconds') + "Z"
        rating = data.get("rating")
        description = data.get("description", None)
        photos = data.get("photos", [])
        user_pic_url = data.get("user_pic_url")

        # From username and bar_name, get user_id and bar_id
        user_response = supabase.table("users").select("user_id").eq("username", username).execute()
        bar_response = supabase.table("bars").select("bar_id").eq("name", bar_name).execute()

        # Validate required fields
        if not rating:
            return jsonify({"error": "Rating is required"}), 400

        response = supabase.table("reviews").insert({
            "user_id": user_response.data[0]["user_id"],
            "bar_id": bar_response.data[0]["bar_id"],
            "publish_time": publish_time,
            "rating": rating,
            "description": description,
            "photos": photos,
            "user_pic_url": user_pic_url
        }).execute()

        if response.error:
            return jsonify({"error": response.error.message}), 400

        return jsonify({
            "message": "Review submitted successfully",
            "review": response.data
        }), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# Flask app route to get the 10 most recent reviews for a user's profile
@app.route("/get-recent-reviews", methods=["GET"])
def get_recent_reviews():
    try:
        # Get username from query parameters
        username = request.args.get("username")
        if not username:
            return jsonify({"error": "Username is required"}), 400

        # Fetch the user_id for the given username
        user_response = supabase.table("users") \
            .select("user_id") \
            .eq("username", username) \
            .execute()

        if not user_response.data or len(user_response.data) == 0:
            return jsonify({"error": "User not found"}), 404

        # Extract the user_id
        user_id = user_response.data[0]["user_id"]

        # Query the reviews table for the user's 10 most recent reviews
        reviews_query = supabase.table("reviews") \
            .select("bar_id, user_id, user_pic_url, rating, description, photos, publish_time") \
            .eq("user_id", user_id) \
            .order("publish_time", desc=True) \
            .limit(10) \
            .execute()

        # Handle missing data
        if not reviews_query.data:
            return jsonify({"error": "No reviews found for the user"}), 404

        # Prepare reviews with associated bar names
        reviews = []
        for review in reviews_query.data:
            # Fetch bar name from bars table
            bar_response = supabase.table("bars") \
                .select("name") \
                .eq("bar_id", review["bar_id"]) \
                .execute()
            bar_name = bar_response.data[0]["name"] if bar_response.data else "Unknown Bar"

            # Construct the review object
            reviews.append({
                "username": username,  # Use the provided username
                "user_pic_url": review.get("user_pic_url", ""),
                "rating": review.get("rating", 0),
                "description": review.get("description", ""),
                "bar": bar_name,
                "photos": review.get("photos", []),  # Default to an empty list if photos are missing
                "publish_time": review.get("publish_time", None),  # Ensure publish_time is included
            })

        # Return the reviews as JSON
        return jsonify({"reviews": reviews}), 200

    except Exception as e:
        # Log and return the exception
        print("Exception in get_recent_reviews:", str(e))
        return jsonify({"error": "An internal server error occurred", "details": str(e)}), 500


# Get all reviews of a user for their profile
@app.route("/get-all-reviews", methods=["GET"])
def get_all_reviews():
    try:
        user_id = request.args.get("user_id")

        response = supabase.table("reviews").select("*").eq("user_id", user_id).execute()

        if response.error:
            return jsonify({"error": response.error.message}), 400

        return jsonify({
            "reviews": response.data
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# Get 10 most recent reviews of a bar
@app.route("/get-recent-bar-reviews", methods=["GET"])
def get_recent_bar_reviews():
    try:
        bar_id = request.args.get("bar_id")

        response = supabase.table("reviews").select("*").eq("bar_id", bar_id).order("publish_time", desc=True).limit(
            10).execute()

        if not response.data:
            return jsonify({"error": response.error.message}), 400

        reviews = []
        for review in response.data:
            user_response = supabase.table("users").select("username").eq("user_id", review["user_id"]).execute()
            bar_response = supabase.table("bars").select("name").eq("bar_id", review["bar_id"]).execute()

            # Safely handle potential missing data
            username = user_response.data[0]["username"] if user_response.data else "Unknown User"
            bar_name = bar_response.data[0]["name"] if bar_response.data else "Unknown Bar"

            reviews.append({
                "username": username,
                "user_pic_url": review["user_pic_url"],
                "rating": review["rating"],
                "description": review["description"],
                "bar": bar_name,
                "photos": review["photos"],
                "publish_time": review["publish_time"]
            })

        # Return the constructed reviews list instead of the raw response.data
        return jsonify({
            "reviews": reviews
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500



# Get 10 most recent reviews of all bars (For the all bars tab)
@app.route("/get-all-bar-reviews", methods=["GET"])
def get_all_bar_reviews():
    try:
        response = supabase.table("reviews").select("*").order("publish_time", desc=True).limit(10).execute()

        if not response.data:
            return jsonify({"error": response.error.message}), 400

        reviews = []
        for review in response.data:
            user_response = supabase.table("users").select("username").eq("user_id", review["user_id"]).execute()
            bar_response = supabase.table("bars").select("name").eq("bar_id", review["bar_id"]).execute()

            reviews.append({
                "username": user_response.data[0]["username"],
                "user_pic_url": review["user_pic_url"],
                "rating": review["rating"],
                "description": review["description"],
                "bar": bar_response.data[0]["name"],
                "photos": review["photos"],
                "publish_time": review["publish_time"]
            })

        return jsonify({
            "reviews": response.data
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# Get 30 most recent reviews to populate feed
@app.route("/get-feed", methods=["GET"])
def get_feed():
    try:
        # Query the Supabase table
        response = supabase.table("reviews").select("*").order("publish_time", desc=True).limit(30).execute()

        # Check if the response contains an error
        if not response.data:  # `response.data` will be `None` if the query failed
            return jsonify({"error": "No data found or query failed"}), 400

        # The frontend expects the struct ReviewInfo: {username, user_pic_url, rating, description, bar, image_url, publish_time}
        # We need to join the reviews with the users and bars tables to get the required information
        reviews = []
        for review in response.data:
            user_response = supabase.table("users").select("username").eq("user_id", review["user_id"]).execute()
            bar_response = supabase.table("bars").select("name").eq("bar_id", review["bar_id"]).execute()

            reviews.append({
                "username": user_response.data[0]["username"],
                "user_pic_url": review["user_pic_url"],
                "rating": review["rating"],
                "description": review["description"],
                "bar": bar_response.data[0]["name"],
                "photos": review["photos"],
                "publish_time": review["publish_time"]
            })

        # Return the reviews in the response
        return jsonify({"reviews": reviews}), 200

    except Exception as e:
        # Log and return the exception
        print("Exception:", str(e))
        return jsonify({"error": str(e)}), 500


# +++++++++++++++++++++++++++++++++++++++++++++ TESTING ROUTES ++++++++++++++++++++++++++++++++++++++++++++++++++++++
# This route is used to test the image retrieval from Supabase and test client connection
@app.route("/get-image", methods=["GET"])
def get_image():
    url = supabase.storage.from_("user-images").get_public_url("ErickCif.jpeg")
    return jsonify({"url": url})


@app.route("/test-register", methods=["GET"])
def test_register_user():
    with app.test_client() as client:
        response = client.post(
            "/register",
            json={
                "username": "Sazu",
                "password": "password1",
                "name": "Erick Cifuentes",
                "email": "erick.cifuentes@columbia.edu",
                "profile_picture": "https://utraejrmcdvwvjzcuogr.supabase.co/storage/v1/object/public/user-images/ErickCif.jpeg"
            }
        )
        return response.data, response.status_code


@app.route("/test-login", methods=["GET"])
def test_login_user():
    with app.test_client() as client:
        response = client.post(
            "/login",
            json={
                "email": "erick.cifuentes@columbia.edu",
                "password": "password1"
            }
        )
        return response.data, response.status_code


@app.route("/test-review", methods=["GET"])
def test_submit_review():
    with app.test_client() as client:
        response = client.post(
            "/submit-review",
            json={
                "username": "Sazu",
                "bar_name": "Amity Hall Uptown",
                "rating": 3,
                "description": "This place is amity.",
                "photos": [
                    "https://utraejrmcdvwvjzcuogr.supabase.co/storage/v1/object/public/bar-images/amity.jpg?t=2024-12-03T05%3A20%3A09.614Z"
                ]
            }
        )
        return response.data, response.status_code


@app.route("/test-get-recent-bar-reviews", methods=["GET"])
def test_get_recent_bar_reviews():
    with app.test_client() as client:
        response = client.get(
            "/get-recent-bar-reviews?bar=Amity Hall Uptown"
        )
        return response.data, response.status_code


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5080)
