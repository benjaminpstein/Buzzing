import Supabase
import Foundation

let serverAddress = "http://127.0.0.1:5080"

class SupabaseManager {
    static let shared = SupabaseManager()
    let client: SupabaseClient

    private init() {
        let supabaseURL = URL(string: "https://utraejrmcdvwvjzcuogr.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV0cmFlanJtY2R2d3ZqemN1b2dyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1ODI4MzQsImV4cCI6MjA0NzE1ODgzNH0.EgR3tTwWrpsvpwRcLoFX5t1sOrPEMTIh64Udfs27YwY"
        self.client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
    }
}

