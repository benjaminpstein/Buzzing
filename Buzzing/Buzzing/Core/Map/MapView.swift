//
//  MapView.swift
//  Buzzing
//
//  Created by Pilar Maldonado on 11/14/24.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    let regionRadius: CLLocationDistance = 1000  // 1 km radius for zoom level
    let coordinate = CLLocationCoordinate2D(
        latitude: 40.8075, longitude: -73.9626)  // Morningside Heights
    let barData: [BarInfo]

    @Binding var selectedBar: BarInfo?
   // Track the selected bar
    @Binding var showReviewView: Bool

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.translatesAutoresizingMaskIntoConstraints = false
    
        mapView.pointOfInterestFilter = .excludingAll

        mapView.overrideUserInterfaceStyle = .dark
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        mapView.setRegion(region, animated: true)
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        for bar in allBars{
            let pin = MKPointAnnotation()
            pin.coordinate = bar.location
            pin.title = bar.name
            mapView.addAnnotation(pin)
        }
        
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the view if needed (e.g., for additional annotations or overlays)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else { return nil }
            
            let identifier = "StarAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                    annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true
                    
                    // Customize the marker
                    if let markerAnnotationView = annotationView as? MKMarkerAnnotationView {
                        markerAnnotationView.markerTintColor = UIColor.systemPurple // Change this to your desired color
                        markerAnnotationView.glyphText = "🍺" // Emoji inside the marker
                    }
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
                    guard let annotation = view.annotation else { return }
                    if let bar = parent.barData.first(where: {
                        $0.location.latitude == annotation.coordinate.latitude &&
                        $0.location.longitude == annotation.coordinate.longitude
                    }) {
                        parent.selectedBar = bar
                        parent.showReviewView = true
                    var adjustedCoordinate = annotation.coordinate
                        adjustedCoordinate.latitude -= 0.002
                    let adjustedRegion = MKCoordinateRegion(
                        center: adjustedCoordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                )
                                mapView.setRegion(adjustedRegion, animated: true)
                        print("Selected bar: \(bar.name)") // Debugging
                    }
                }
    }
        

}

struct MapWithBarReviews: View {
    @State private var selectedBar: BarInfo? = nil
    @State private var showReviewView = false
    @State private var dragOffset: CGFloat = UIScreen.main.bounds.height * 0.5 // Start at half-screen height
    @State private var reviewsGroupedByBar: [Int: [ReviewInfo]] = [:]
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var isEmptyState = false

    var body: some View {
        ZStack {
            // Static MapView in the background
            MapView(
                barData: allBars,
                selectedBar: $selectedBar,
                showReviewView: $showReviewView
            )
            .edgesIgnoringSafeArea(.all)

            // Draggable Bar Review View
            if let bar = selectedBar, let barReviews = reviewsGroupedByBar[bar.bar_id] {
                BarReviewStackView(barData: bar, barStackData: barReviews)
                    .background(Color(.systemBackground).cornerRadius(16))
                    .offset(y: dragOffset) // Control position with drag offset
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let newOffset = dragOffset + gesture.translation.height
                                dragOffset = max(UIScreen.main.bounds.height * 0.2, newOffset) // Minimum height
                            }
                            .onEnded { _ in
                                let midPoint = UIScreen.main.bounds.height * 0.5
                                dragOffset = dragOffset < midPoint
                                    ? UIScreen.main.bounds.height * 0.09 // Snap to top
                                    : UIScreen.main.bounds.height * 0.5 // Snap to middle
                            }
                    )
                    .animation(.spring(), value: dragOffset) // Smooth animation
                    .zIndex(1) // Ensure it's above the map
            }
        }
        .onAppear {
            fetchAllBarReviews()
        }
    }
    
    private func fetchAllBarReviews() {
            isLoading = true
            errorMessage = nil
            isEmptyState = false
            print("[DEBUG] Fetching reviews for all bars")

            for bar in allBars {
                getBarReviews(barID: bar.bar_id)
            }
        }
    
    func getBarReviews(barID: Int) {
            print("[DEBUG] Fetching reviews for Bar ID: \(barID)")

            guard let url = URL(string: "\(serverAddress)/get-recent-bar-reviews?bar_id=\(String(barID))") else {
                errorMessage = "Invalid server URL"
                print("[DEBUG] Invalid server URL: \(serverAddress)/get-recent-bar-reviews?bar_id=\(String(barID))")
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        errorMessage = "Error: \(error.localizedDescription)"
                        isLoading = false
                        print("[DEBUG] Network error: \(error.localizedDescription)")
                    }
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("[DEBUG] HTTP Response Code: \(httpResponse.statusCode)")
                    if httpResponse.statusCode == 404 {
                        DispatchQueue.main.async {
                            isEmptyState = true
                            print("[DEBUG] No reviews found for Bar ID: \(barID) (404)")
                        }
                        return
                    } else if httpResponse.statusCode != 200 {
                        DispatchQueue.main.async {
                            errorMessage = "Failed to fetch reviews (HTTP \(httpResponse.statusCode))"
                            print("[DEBUG] Non-200 HTTP status code: \(httpResponse.statusCode)")
                        }
                        return
                    }
                }

                guard let data = data else {
                    DispatchQueue.main.async {
                        errorMessage = "No data received from server"
                        print("[DEBUG] No data received from server for Bar ID: \(barID)")
                    }
                    return
                }

                // Print raw JSON for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("[DEBUG] Raw JSON Response: \(jsonString)")
                }

                do {
                    // Decode the JSON response
                    let decoder = JSONDecoder()
                    let iso8601Formatter = DateFormatter()
                    iso8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    iso8601Formatter.timeZone = TimeZone(secondsFromGMT: 0)
                    decoder.dateDecodingStrategy = .formatted(iso8601Formatter)

                    let response = try decoder.decode(FeedResponse.self, from: data)

                    DispatchQueue.main.async {
                        reviewsGroupedByBar[barID] = response.reviews
                        print("[DEBUG] Successfully fetched and parsed reviews for Bar ID: \(barID). Total reviews: \(response.reviews.count)")
                    }
                } catch {
                    DispatchQueue.main.async {
                        errorMessage = "Failed to parse reviews: \(error.localizedDescription)"
                        print("[DEBUG] JSON parsing error for Bar ID: \(barID): \(error.localizedDescription)")
                    }
                }
            }

            task.resume()
        }

}




#Preview {
    MapWithBarReviews()
}
