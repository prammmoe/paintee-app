//
//  PurchaseManager.swift
//  Paintee
//
//  Created by Abdul Jabbar on 18/07/25.
//
import StoreKit

class PurchaseManager: ObservableObject {
    @Published var unlockedProductIDs: Set<String> = []
    
    // Define product IDs (App Store Connect product IDs)
    private let productIDs: Set<String> = [
        "com.paintee.diademuertos", // Dia de Muertos
        "com.paintee.tiger"         // Tiger
    ]
    
    @Published var products: [Product] = [] // Array of products fetched from App Store
    
    init() {
        loadUnlockedProducts() // Load unlocked products on init
        fetchProducts()        // Fetch available products from App Store
    }
    
    // Fetch available products using StoreKit 2
    func fetchProducts() {
        Task {
            do {
                let fetchedProducts = try await Product.products(for: productIDs)
                print("Fetched products:", fetchedProducts)
                DispatchQueue.main.async {
                    self.products = fetchedProducts
                }
            } catch {
                print("Failed to fetch products: \(error.localizedDescription)")
            }
        }
    }

    
    // Start a purchase for a specific product
    func purchase(productID: String, completion: @escaping (Bool) -> Void) {
        print("Attempting purchase for productID:", productID)
        print("Available products:", products.map { $0.id })
        guard let product = products.first(where: { $0.id == productID }) else {
            print("Product ID not found in loaded products.")
            completion(false)
            return
        }

        
        Task {
            do {
                // Start the purchase process
                let result = try await product.purchase()
                
                // Handle the result
                switch result {
                case .success(let verificationResult):
                    // If the transaction is verified, unlock the product
                    if case .verified = verificationResult {
                        unlock(productID: product.id)
                        completion(true)
                    } else {
                        completion(false)
                    }
                case .userCancelled:
                    print("User cancelled the purchase.")
                    completion(false)
                case .pending:
                    print("Purchase is pending, waiting for approval or further action.")
                    completion(false)
                @unknown default:
                    print("Unknown purchase result.")
                    completion(false)
                }
            } catch {
                // Any error that happens during purchase comes here
                print("Purchase failed with error: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    // Unlock the product after successful purchase
    private func unlock(productID: String) {
        DispatchQueue.main.async {
            self.unlockedProductIDs.insert(productID)
            UserDefaults.standard.set(true, forKey: productID)
            self.saveUnlockedProducts()
        }
    }
    // Load unlocked products from UserDefaults
    func loadUnlockedProducts() {
        for id in productIDs {
            if UserDefaults.standard.bool(forKey: id) {
                unlockedProductIDs.insert(id)
            }
        }
    }
    
    // Save unlocked products to UserDefaults
    private func saveUnlockedProducts() {
        UserDefaults.standard.set(Array(unlockedProductIDs), forKey: "unlockedProductIDs")
    }
    
    // Restore all purchases (called when user wants to restore purchases)
    func restorePurchases() {
        // Simulate restoring purchases
        // In a real implementation, you'd use StoreKit's restore functionality here
        loadUnlockedProducts() // Load previously unlocked products from UserDefaults
        print("Purchases restored: \(unlockedProductIDs)")
    }
}
