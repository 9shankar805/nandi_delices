/**
 * Nandi Delices - Restaurant Configuration
 * Defines default settings and localized configuration matching DATA_MODEL.md
 */

const DEFAULT_CONFIG = {
  name: "Nandi Delices",
  tagline: "Home Style Food",
  subtitle: "Saveurs authentiques & Fait Maison",
  // International format without + or spaces for wa.me URL
  whatsappNumber: "33612345678", 
  phone: "+33 6 12 34 56 78",
  currency: "EUR",
  currencySymbol: "€",
  deliveryFee: 2.00,
  minOrderAmount: 0.00,
  address: "Restaurant Nandi Delices, 75010 Paris",
  openingHours: "Mardi – Dimanche : 11h30 – 15h00 & 18h30 – 22h30",
  isOpenNow: true,
  instagramUrl: "https://instagram.com",
  facebookUrl: "https://facebook.com",
  allowPickup: true,
  allowDelivery: true
};

// Load user-saved overrides if any, otherwise default
function getRestaurantConfig() {
  const saved = localStorage.getItem('nandi_restaurant_config');
  if (saved) {
    try {
      return { ...DEFAULT_CONFIG, ...JSON.parse(saved) };
    } catch (e) {
      console.error("Error reading saved configuration", e);
    }
  }
  return DEFAULT_CONFIG;
}

function saveRestaurantConfig(newConfig) {
  const current = getRestaurantConfig();
  const updated = { ...current, ...newConfig };
  localStorage.setItem('nandi_restaurant_config', JSON.stringify(updated));
  return updated;
}
