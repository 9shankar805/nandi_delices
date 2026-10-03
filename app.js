/**
 * Nandi Delices - Multi-Page Web Application Logic
 * Shared state & page-specific controllers for:
 * - Home (index.html)
 * - Menu (menu.html)
 * - Cart & Checkout (cart.html)
 * - About & Contact (about.html)
 */

// =============================================================================
// I18N DICTIONARY (FRENCH & ENGLISH)
// =============================================================================
const TRANSLATIONS = {
  fr: {
    nav_home: "Accueil",
    nav_menu: "Notre Carte",
    nav_cart: "Panier & Commande",
    nav_about: "Le Restaurant",
    mob_nav_home: "Accueil",
    mob_nav_menu: "Carte",
    mob_nav_cart: "Panier",
    mob_nav_about: "Restaurant",
    hero_badge: "Saveurs Authentiques & Fait Maison",
    hero_title_1: "Goût Authentique,",
    hero_title_2: "Saveurs Maison",
    hero_subtitle: "Dégustez nos samoussas dorés, currys parfumés, biryanis traditionnels et douceurs créoles préparés chaque jour avec passion.",
    cta_order_now: "Commander Maintenant",
    cta_discover: "Découvrir le restaurant",
    closed_badge: "ACTUELLEMENT FERMÉ",
    preorder_open: "Pré-commandes ouvertes",
    closed_desc: "Le restaurant est actuellement fermé. Vous pouvez toujours composer votre panier et envoyer votre commande sur WhatsApp pour la prochaine ouverture !",
    closed_whatsapp_btn: "Poser une question sur WhatsApp",
    mode_delivery_title: "Livraison Rapide",
    mode_delivery_desc: "Plats chauds livrés directement chez vous par notre équipe.",
    mode_pickup_title: "À Emporter / Sur Place",
    mode_pickup_desc: "Retrait rapide au restaurant avec 0 frais supplémentaire.",
    mode_wa_title: "Commande Directe WhatsApp",
    mode_wa_desc: "Message pré-rempli instantané, confirmation immédiate.",
    step_1_title: "Choisissez",
    step_1_desc: "Parcourez notre carte gourmande",
    step_2_title: "Remplissez",
    step_2_desc: "Ajoutez vos plats au panier",
    step_3_title: "Localisez",
    step_3_desc: "Indiquez votre adresse de livraison",
    step_4_title: "Validez",
    step_4_desc: "Envoi en 1 clic sur WhatsApp",
    menu_subtitle: "FAIT MAISON AVEC AMOUR",
    home_featured_title: "Nos Spécialités Phares",
    view_full_menu_btn: "Explorer Toute la Carte (37 Plats)",
    menu_page_title: "Notre Carte Gourmande",
    menu_page_subtitle: "37 recettes authentiques faites maison préparées chaque jour avec des épices sélectionnées.",
    cart_page_title: "Votre Panier & Commande",
    cart_page_subtitle: "Vérifiez vos articles et renseignez vos informations pour un envoi instantané sur WhatsApp.",
    about_page_title: "Notre Histoire & Le Restaurant",
    about_page_subtitle: "L'amour des recettes traditionnelles mauriciennes, des épices fraîches et du partage familial.",
    search_placeholder: "Rechercher un plat (samoussa, biryani, curry...)",
    filter_veg: "Végétarien uniquement",
    filter_spicy: "Épicé",
    about_subtitle: "NOTRE PASSION",
    about_title: "Bienvenue chez Nandi Delices",
    about_desc: "Nandi Delices vous invite à un voyage culinaire unique aux saveurs authentiques et traditionnelles. Nos recettes sont préparées chaque jour à base d'ingrédients frais et d'épices rigoureusement sélectionnées. Des samoussas croustillants aux currys mijotés, découvrez le véritable goût du fait maison.",
    about_learn_more: "En savoir plus sur le restaurant &rarr;",
    hours_title: "⏰ Horaires d'Ouverture",
    days_open: "Mardi – Dimanche",
    days_closed: "Lundi",
    status_closed: "Fermé",
    status_open: "Ouvert",
    contact_whatsapp_btn: "Nous contacter sur WhatsApp",
    value_1_title: "100% Fait Maison",
    value_1_desc: "Pâtes roulées à la main, currys mijotés plusieurs heures et sauces artisanales.",
    value_2_title: "Épices & Fraîcheur",
    value_2_desc: "Mélanges d'épices torréfiées maison et ingrédients frais livrés chaque matin.",
    value_3_title: "Générosité & Passion",
    value_3_desc: "Des portions copieuses et un accueil chaleureux comme à la maison.",
    restaurant_location_title: "Localisation du Restaurant",
    footer_about: "Restaurant de spécialités maison. Commandez vos plats préférés et faites-vous livrer ou récupérez votre commande à emporter directement sur WhatsApp.",
    footer_contact_title: "Contact & Adresse",
    footer_quick_links: "Pages du Site",
    footer_signature: "Fait avec passion & saveurs authentiques.",
    settings_title: "Réglages Restaurant",
    cart_title: "Votre Panier",
    cart_empty: "Votre panier est vide. Ajoutez de délicieux plats pour commander !",
    cart_subtotal: "Sous-total :",
    cart_delivery_fee: "Frais de livraison :",
    cart_total: "Total :",
    checkout_step_details: "Détails de Livraison",
    cart_summary_title: "Récapitulatif du Panier",
    order_mode_label: "Mode de commande",
    mode_delivery_opt: "Livraison (+2.00 €)",
    mode_pickup_opt: "À Emporter (0 €)",
    cust_name_label: "Votre Nom *",
    cust_phone_label: "Numéro de téléphone *",
    cust_address_label: "Adresse de livraison complète *",
    btn_pick_map: "Choisir sur la carte",
    btn_use_gps: "Ma position GPS",
    map_modal_title: "Choisir sur la carte",
    map_modal_sub: "Recherchez votre adresse ou déplacez le repère",
    map_search_btn: "Rechercher",
    map_drag_hint: "📍 Touchez ou déplacez le repère pour ajuster",
    map_selected_address_label: "Adresse sélectionnée :",
    map_confirm_text: "Confirmer et ajouter cette adresse",
    map_pin_hint: "📍 Déplacez le repère sur la carte",
    gps_btn: "Ma position GPS exacte",
    cust_time_label: "Heure de livraison souhaitée",
    cust_notes_label: "Notes complémentaires (allergies, code porte...)",
    btn_confirm_whatsapp: "Envoyer ma commande sur WhatsApp",
    cart_continue_browsing: "← Continuer mes achats sur la carte",
    btn_add_to_cart: "Ajouter au panier",
    settings_open_label: "Statut Ouvert / Fermé",
    settings_wa_label: "Numéro WhatsApp (sans + ni espaces)",
    settings_addr_label: "Adresse du restaurant",
    settings_hours_label: "Horaires d'ouverture",
    btn_save: "Enregistrer les réglages",
    badge_veg: "🌱 Végétarien",
    badge_spicy: "🌶️ Épicé",
    per_piece: "pièce",
    portion: "portion"
  },
  en: {
    nav_home: "Home",
    nav_menu: "Our Menu",
    nav_cart: "Cart & Checkout",
    nav_about: "About Us",
    mob_nav_home: "Home",
    mob_nav_menu: "Menu",
    mob_nav_cart: "Cart",
    mob_nav_about: "About",
    hero_badge: "Authentic Flavors & Homemade",
    hero_title_1: "Authentic Taste,",
    hero_title_2: "Home Style Food",
    hero_subtitle: "Enjoy our golden samosas, aromatic curries, traditional biryanis, and homemade sweets prepared daily with love.",
    cta_order_now: "Order Now",
    cta_discover: "Discover Restaurant",
    closed_badge: "CURRENTLY CLOSED",
    preorder_open: "Pre-orders open",
    closed_desc: "The restaurant is currently closed. You can still prepare your cart and send your WhatsApp order for our next opening!",
    closed_whatsapp_btn: "Ask a question on WhatsApp",
    mode_delivery_title: "Fast Delivery",
    mode_delivery_desc: "Hot dishes delivered straight to your door by our team.",
    mode_pickup_title: "Takeaway / Dine-in",
    mode_pickup_desc: "Quick pickup directly at our restaurant with 0 extra fees.",
    mode_wa_title: "Direct WhatsApp Order",
    mode_wa_desc: "Instant pre-filled message, quick order confirmation.",
    step_1_title: "Choose",
    step_1_desc: "Browse our authentic menu",
    step_2_title: "Fill Cart",
    step_2_desc: "Add your favorite dishes",
    step_3_title: "Locate",
    step_3_desc: "Set your delivery address",
    step_4_title: "Send",
    step_4_desc: "1-click order via WhatsApp",
    menu_subtitle: "HOMEMADE WITH LOVE",
    home_featured_title: "Our Featured Dishes",
    view_full_menu_btn: "Explore Full Menu (37 Dishes)",
    menu_page_title: "Our Delicious Menu",
    menu_page_subtitle: "37 authentic homemade recipes prepared daily with curated traditional spices.",
    cart_page_title: "Your Cart & Checkout",
    cart_page_subtitle: "Review your items and enter your details for an instant order via WhatsApp.",
    about_page_title: "Our Story & Restaurant",
    about_page_subtitle: "Passion for authentic Mauritian recipes, fresh spices, and family warmth.",
    search_placeholder: "Search dishes (samosa, biryani, curry...)",
    filter_veg: "Vegetarian only",
    filter_spicy: "Spicy",
    about_subtitle: "OUR PASSION",
    about_title: "Welcome to Nandi Delices",
    about_desc: "Nandi Delices invites you to an authentic culinary journey filled with home-style traditional recipes. Our dishes are lovingly prepared daily with fresh ingredients and curated spices. From crunchy samosas to slow-cooked curries, taste the real difference of homemade cooking.",
    about_learn_more: "Learn more about our restaurant &rarr;",
    hours_title: "⏰ Opening Hours",
    days_open: "Tuesday – Sunday",
    days_closed: "Monday",
    status_closed: "Closed",
    status_open: "Open",
    contact_whatsapp_btn: "Contact us on WhatsApp",
    value_1_title: "100% Homemade",
    value_1_desc: "Hand-rolled pastry, slow-cooked curries, and artisanal dips.",
    value_2_title: "Spices & Freshness",
    value_2_desc: "House-roasted spice blends and fresh local produce delivered daily.",
    value_3_title: "Warm Hospitality",
    value_3_desc: "Generous portions and a warm welcoming home-style experience.",
    restaurant_location_title: "Restaurant Location",
    footer_about: "Home-style food specialist restaurant. Order your favorite dishes for home delivery or takeaway pickup directly through WhatsApp.",
    footer_contact_title: "Contact & Address",
    footer_quick_links: "Website Pages",
    footer_signature: "Crafted with passion & authentic flavors.",
    settings_title: "Restaurant Settings",
    cart_title: "Your Cart",
    cart_empty: "Your cart is empty. Add delicious items to place an order!",
    cart_subtotal: "Subtotal:",
    cart_delivery_fee: "Delivery fee:",
    cart_total: "Total:",
    checkout_step_details: "Delivery Details",
    cart_summary_title: "Cart Summary",
    order_mode_label: "Order Mode",
    mode_delivery_opt: "Delivery (+€2.00)",
    mode_pickup_opt: "Takeaway (€0)",
    cust_name_label: "Your Name *",
    cust_phone_label: "Phone Number *",
    cust_address_label: "Complete Delivery Address *",
    btn_pick_map: "Select from Map",
    btn_use_gps: "My GPS Position",
    map_modal_title: "Select from Map",
    map_modal_sub: "Search your address or drag the pin",
    map_search_btn: "Search",
    map_drag_hint: "📍 Tap or drag the pin to adjust position",
    map_selected_address_label: "Selected address:",
    map_confirm_text: "Confirm & Add this address",
    map_pin_hint: "📍 Drag the pin on map",
    gps_btn: "My Exact GPS Position",
    cust_time_label: "Preferred Delivery Time",
    cust_notes_label: "Additional Notes (allergies, door code...)",
    btn_confirm_whatsapp: "Send Order on WhatsApp",
    cart_continue_browsing: "← Continue browsing the menu",
    btn_add_to_cart: "Add to Cart",
    settings_open_label: "Open / Closed Status",
    settings_wa_label: "WhatsApp Number (no + or spaces)",
    settings_addr_label: "Restaurant Address",
    settings_hours_label: "Opening Hours",
    btn_save: "Save Settings",
    badge_veg: "🌱 Vegetarian",
    badge_spicy: "🌶️ Spicy",
    per_piece: "piece",
    portion: "portion"
  }
};

// =============================================================================
// GLOBAL STATE
// =============================================================================
let currentLang = localStorage.getItem('nandi_lang') || 'fr';
let currentCategory = 'all';
let searchQuery = '';
let filterVegetarian = false;
let filterSpicy = false;
let cart = JSON.parse(localStorage.getItem('nandi_cart') || '[]');
let currentOrderMode = 'delivery';
let mapInstance = null;
let mapMarker = null;

// Map Modal State
let pickerMapInstance = null;
let pickerMapMarker = null;
let selectedMapLat = 48.8752;
let selectedMapLng = 2.3551;
let selectedMapAddress = '';

// =============================================================================
// INITIALIZATION ROUTER
// =============================================================================
document.addEventListener('DOMContentLoaded', () => {
  initLanguage();
  initRestaurantConfig();
  updateCartBadge();

  const page = document.body.getAttribute('data-page') || 'home';

  if (page === 'home') {
    initHomePage();
  } else if (page === 'menu') {
    initMenuPage();
  } else if (page === 'cart') {
    initCartPage();
  } else if (page === 'about') {
    initAboutPage();
  }

  initGlobalEvents();
});

// =============================================================================
// LANGUAGE TOGGLE & TRANSLATIONS
// =============================================================================
function initLanguage() {
  updateLanguageUI();

  const toggleBtn = document.getElementById('lang-toggle-btn');
  if (toggleBtn) {
    toggleBtn.addEventListener('click', () => {
      currentLang = currentLang === 'fr' ? 'en' : 'fr';
      localStorage.setItem('nandi_lang', currentLang);
      updateLanguageUI();

      const page = document.body.getAttribute('data-page') || 'home';
      if (page === 'home') {
        renderFeaturedDishes();
      } else if (page === 'menu') {
        initCategoryTabs();
        renderFullMenu();
      } else if (page === 'cart') {
        renderCartPageItems();
      }
    });
  }
}

function updateLanguageUI() {
  const t = TRANSLATIONS[currentLang];
  document.documentElement.lang = currentLang;

  const flagEl = document.getElementById('lang-flag');
  const textEl = document.getElementById('lang-text');
  if (flagEl) flagEl.textContent = currentLang === 'fr' ? '🇬🇧' : '🇫🇷';
  if (textEl) textEl.textContent = currentLang === 'fr' ? 'EN' : 'FR';

  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.getAttribute('data-i18n');
    if (t[key]) el.innerHTML = t[key];
  });

  document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
    const key = el.getAttribute('data-i18n-placeholder');
    if (t[key]) el.placeholder = t[key];
  });
}

// =============================================================================
// RESTAURANT CONFIGURATION
// =============================================================================
function initRestaurantConfig() {
  const config = getRestaurantConfig();

  const nameEl = document.getElementById('nav-restaurant-name');
  const tagEl = document.getElementById('nav-restaurant-tagline');
  const addrEl = document.getElementById('footer-address');
  const phoneEl = document.getElementById('footer-phone');
  const waEl = document.getElementById('footer-whatsapp');

  if (nameEl) nameEl.textContent = config.name;
  if (tagEl) tagEl.textContent = config.tagline;
  if (addrEl) addrEl.textContent = config.address;
  if (phoneEl) phoneEl.textContent = config.phone;
  if (waEl) waEl.textContent = `WhatsApp : ${config.phone}`;

  const closedBanner = document.getElementById('closed-banner');
  if (closedBanner) {
    closedBanner.style.display = !config.isOpenNow ? 'block' : 'none';
    const hoursEl = document.getElementById('closed-banner-hours');
    if (hoursEl) hoursEl.textContent = config.openingHours;
  }

  const closedWaBtn = document.getElementById('closed-whatsapp-inquiry-btn');
  if (closedWaBtn) {
    closedWaBtn.onclick = () => {
      const msg = currentLang === 'fr'
        ? "Bonjour Nandi Delices, je souhaite savoir à quelle heure vous ouvrez aujourd'hui !"
        : "Hello Nandi Delices, I would like to know what time you open today!";
      window.open(`https://wa.me/${config.whatsappNumber}?text=${encodeURIComponent(msg)}`, '_blank');
    };
  }
}

// =============================================================================
// CART GLOBAL STATE & BADGE
// =============================================================================
function updateCartBadge() {
  const totalCount = cart.reduce((sum, item) => sum + item.quantity, 0);
  const navBadge = document.getElementById('nav-cart-badge');
  const mobBadge = document.getElementById('mobile-cart-badge');

  if (navBadge) {
    navBadge.textContent = totalCount;
    navBadge.style.display = totalCount > 0 ? 'flex' : 'none';
  }
  if (mobBadge) {
    mobBadge.textContent = totalCount;
    mobBadge.style.display = totalCount > 0 ? 'flex' : 'none';
  }
}

function updateItemQty(itemId, delta) {
  const item = MENU_ITEMS.find(m => m.id === itemId);
  if (!item) return;

  const existingIdx = cart.findIndex(c => c.id === itemId);
  if (existingIdx > -1) {
    cart[existingIdx].quantity += delta;
    if (cart[existingIdx].quantity <= 0) {
      cart.splice(existingIdx, 1);
    }
  } else if (delta > 0) {
    cart.push({
      id: item.id,
      quantity: 1,
      price: item.price,
      nameFr: item.nameFr,
      nameEn: item.nameEn,
      image: item.image,
      unit: item.unit
    });
  }

  localStorage.setItem('nandi_cart', JSON.stringify(cart));
  updateCartBadge();

  const page = document.body.getAttribute('data-page') || 'home';
  if (page === 'home') {
    renderFeaturedDishes();
  } else if (page === 'menu') {
    renderFullMenu();
  } else if (page === 'cart') {
    renderCartPageItems();
  }
}

// =============================================================================
// 1. HOME PAGE CONTROLLER
// =============================================================================
function initHomePage() {
  initHeroSlider();
  renderFeaturedDishes();
}

function initHeroSlider() {
  const slides = document.querySelectorAll('.hero-slide');
  const dots = document.querySelectorAll('.hero-slider-dots .dot');
  if (slides.length === 0) return;

  let currentSlide = 0;
  let sliderTimer = null;

  const showSlide = (index) => {
    slides.forEach((s, i) => s.classList.toggle('active', i === index));
    dots.forEach((d, i) => d.classList.toggle('active', i === index));
    currentSlide = index;
  };

  const nextSlide = () => {
    const next = (currentSlide + 1) % slides.length;
    showSlide(next);
  };

  sliderTimer = setInterval(nextSlide, 4500);

  dots.forEach(dot => {
    dot.addEventListener('click', (e) => {
      const idx = parseInt(e.target.getAttribute('data-index'), 10);
      showSlide(idx);
      clearInterval(sliderTimer);
      sliderTimer = setInterval(nextSlide, 4500);
    });
  });
}

function renderFeaturedDishes() {
  const container = document.getElementById('food-grid-featured');
  if (!container) return;

  const items = window.MENU_ITEMS || (typeof MENU_ITEMS !== 'undefined' ? MENU_ITEMS : []);
  const featured = items.slice(0, 6);
  const t = TRANSLATIONS[currentLang];

  container.innerHTML = featured.map(item => createFoodCardHTML(item, t)).join('');
}

// =============================================================================
// 2. MENU PAGE CONTROLLER
// =============================================================================
function initMenuPage() {
  initCategoryTabs();
  renderFullMenu();

  const searchInput = document.getElementById('menu-search-input');
  const clearSearchBtn = document.getElementById('clear-search-btn');

  if (searchInput) {
    searchInput.addEventListener('input', (e) => {
      searchQuery = e.target.value.trim().toLowerCase();
      if (clearSearchBtn) clearSearchBtn.style.display = searchQuery ? 'block' : 'none';
      renderFullMenu();
    });
  }

  if (clearSearchBtn) {
    clearSearchBtn.addEventListener('click', () => {
      if (searchInput) searchInput.value = '';
      searchQuery = '';
      clearSearchBtn.style.display = 'none';
      renderFullMenu();
    });
  }

  const vegBtn = document.getElementById('filter-veg-btn');
  if (vegBtn) {
    vegBtn.addEventListener('click', () => {
      filterVegetarian = !filterVegetarian;
      vegBtn.classList.toggle('active', filterVegetarian);
      renderFullMenu();
    });
  }

  const spicyBtn = document.getElementById('filter-spicy-btn');
  if (spicyBtn) {
    spicyBtn.addEventListener('click', () => {
      filterSpicy = !filterSpicy;
      spicyBtn.classList.toggle('active', filterSpicy);
      renderFullMenu();
    });
  }

  const closeItemModalBtn = document.getElementById('close-item-modal-btn');
  if (closeItemModalBtn) {
    closeItemModalBtn.addEventListener('click', closeItemModal);
  }
}

function initCategoryTabs() {
  const container = document.getElementById('category-tabs');
  if (!container) return;
  container.innerHTML = '';

  CATEGORIES.forEach(cat => {
    const name = currentLang === 'fr' ? cat.nameFr : cat.nameEn;
    const btn = document.createElement('button');
    btn.className = `category-pill ${cat.id === currentCategory ? 'active' : ''}`;
    btn.innerHTML = `<span>${cat.icon}</span> <span>${name}</span>`;

    btn.addEventListener('click', () => {
      currentCategory = cat.id;
      document.querySelectorAll('.category-pill').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      renderFullMenu();
    });

    container.appendChild(btn);
  });
}

function renderFullMenu() {
  const container = document.getElementById('food-grid');
  if (!container) return;
  const items = window.MENU_ITEMS || (typeof MENU_ITEMS !== 'undefined' ? MENU_ITEMS : []);
  const t = TRANSLATIONS[currentLang];

  const filtered = items.filter(item => {
    const matchesCat = currentCategory === 'all' || item.category === currentCategory;
    const name = ((currentLang === 'fr' ? item.nameFr : (item.nameEn || item.nameFr)) || '').toLowerCase();
    const desc = ((currentLang === 'fr' ? item.descriptionFr : (item.descriptionEn || item.descriptionFr)) || '').toLowerCase();
    const matchesSearch = !searchQuery || name.includes(searchQuery) || desc.includes(searchQuery);
    const matchesVeg = !filterVegetarian || Boolean(item.isVegetarian);
    const matchesSpicy = !filterSpicy || (item.spiceLevel && item.spiceLevel > 0);

    return matchesCat && matchesSearch && matchesVeg && matchesSpicy;
  });

  if (filtered.length === 0) {
    container.innerHTML = `
      <div style="grid-column: 1 / -1; text-align: center; padding: 4rem 1rem; color: var(--muted-text);">
        <span style="font-size: 3rem; display:block; margin-bottom:1rem;">🔍</span>
        <h3>${currentLang === 'fr' ? 'Aucun plat ne correspond à votre recherche.' : 'No dishes match your search.'}</h3>
        <p>${currentLang === 'fr' ? 'Essayez de réinitialiser vos filtres.' : 'Try resetting your filters.'}</p>
      </div>
    `;
    return;
  }

  container.innerHTML = filtered.map(item => createFoodCardHTML(item, t)).join('');
}

function createFoodCardHTML(item, t) {
  const name = (currentLang === 'fr' ? item.nameFr : (item.nameEn || item.nameFr)) || item.nameFr;
  const desc = (currentLang === 'fr' ? item.descriptionFr : (item.descriptionEn || item.descriptionFr)) || item.descriptionFr;
  const unitLabel = item.unit === 'pièce' ? t.per_piece : t.portion;

  const cartItem = cart.find(c => c.id === item.id);
  const qty = cartItem ? cartItem.quantity : 0;

  const vegBadge = item.isVegetarian ? `<span class="badge-veg">${t.badge_veg}</span>` : '';
  const spicyBadge = (item.spiceLevel && item.spiceLevel > 0) ? `<span class="badge-spicy">${t.badge_spicy}</span>` : '';

  return `
    <article class="food-card" data-id="${item.id}">
      <div class="food-img-wrap" onclick="openItemDetail('${item.id}')">
        <img src="${item.image}" alt="${name}" class="food-img" loading="lazy" onerror="this.src='assets/hero-banner.jpg'">
        <div class="food-badges">
          ${vegBadge}
          ${spicyBadge}
        </div>
      </div>
      <div class="food-details">
        <h3 class="food-name" onclick="openItemDetail('${item.id}')">${name}</h3>
        <p class="food-desc">${desc}</p>
        <div class="food-footer">
          <div>
            <span class="food-price">${Number(item.price).toFixed(2)} €</span>
            <span class="food-unit">/ ${unitLabel}</span>
          </div>
          <div>
            ${qty > 0 ? `
              <div class="qty-stepper">
                <button class="qty-btn" onclick="updateItemQty('${item.id}', -1)" type="button">-</button>
                <span class="qty-num">${qty}</span>
                <button class="qty-btn" onclick="updateItemQty('${item.id}', 1)" type="button">+</button>
              </div>
            ` : `
              <button class="add-btn" onclick="updateItemQty('${item.id}', 1)" type="button">
                <span>+</span> <span>${t.btn_add_to_cart}</span>
              </button>
            `}
          </div>
        </div>
      </div>
    </article>
  `;
}

function openItemDetail(itemId) {
  const item = MENU_ITEMS.find(m => m.id === itemId);
  if (!item) return;

  const modal = document.getElementById('item-modal');
  if (!modal) return;

  const t = TRANSLATIONS[currentLang];
  const name = currentLang === 'fr' ? item.nameFr : item.nameEn;
  const desc = currentLang === 'fr' ? item.descriptionFr : item.descriptionEn;
  const unitLabel = item.unit === 'pièce' ? t.per_piece : t.portion;

  document.getElementById('item-modal-title').textContent = name;
  document.getElementById('item-modal-img').src = item.image;
  document.getElementById('item-modal-img').alt = name;
  document.getElementById('item-modal-price').textContent = `${item.price.toFixed(2)} € / ${unitLabel}`;
  document.getElementById('item-modal-desc').textContent = desc;

  const badgesBox = document.getElementById('item-modal-badges');
  badgesBox.innerHTML = '';
  if (item.isVegetarian) badgesBox.innerHTML += `<span class="badge-veg">${t.badge_veg}</span>`;
  if (item.spiceLevel > 0) badgesBox.innerHTML += `<span class="badge-spicy">${t.badge_spicy}</span>`;

  const addBtn = document.getElementById('item-modal-add-btn');
  addBtn.onclick = () => {
    updateItemQty(item.id, 1);
    closeItemModal();
  };

  modal.classList.add('open');
}

function closeItemModal() {
  const modal = document.getElementById('item-modal');
  if (modal) modal.classList.remove('open');
}

// =============================================================================
// 3. CART & CHECKOUT PAGE CONTROLLER
// =============================================================================
function initCartPage() {
  renderCartPageItems();

  const btnDelivery = document.getElementById('btn-mode-delivery');
  const btnPickup = document.getElementById('btn-mode-pickup');
  const deliveryGroup = document.getElementById('delivery-address-group');
  const deliveryLine = document.getElementById('cart-page-delivery-line');

  if (btnDelivery && btnPickup) {
    btnDelivery.addEventListener('click', () => {
      currentOrderMode = 'delivery';
      btnDelivery.classList.add('active');
      btnPickup.classList.remove('active');
      if (deliveryGroup) deliveryGroup.style.display = 'block';
      if (deliveryLine) deliveryLine.style.display = 'flex';
      renderCartPageItems();
    });

    btnPickup.addEventListener('click', () => {
      currentOrderMode = 'pickup';
      btnPickup.classList.add('active');
      btnDelivery.classList.remove('active');
      if (deliveryGroup) deliveryGroup.style.display = 'none';
      if (deliveryLine) deliveryLine.style.display = 'none';
      renderCartPageItems();
    });
  }

  // Location Picker Modal triggers
  const openMapBtn = document.getElementById('open-map-picker-btn');
  if (openMapBtn) openMapBtn.addEventListener('click', openMapPickerModal);

  const quickGpsBtn = document.getElementById('quick-gps-btn');
  if (quickGpsBtn) quickGpsBtn.addEventListener('click', detectDirectGPS);

  const closeMapBtn = document.getElementById('close-map-modal-btn');
  if (closeMapBtn) closeMapBtn.addEventListener('click', closeMapPickerModal);

  const mapModal = document.getElementById('map-picker-modal');
  if (mapModal) {
    mapModal.addEventListener('click', (e) => {
      if (e.target === mapModal) closeMapPickerModal();
    });
  }

  const mapSearchBtn = document.getElementById('map-modal-search-btn');
  const mapSearchInput = document.getElementById('map-modal-search-input');
  const mapSearchClear = document.getElementById('map-modal-clear-search');

  if (mapSearchBtn) mapSearchBtn.addEventListener('click', searchMapLocation);
  if (mapSearchInput) {
    mapSearchInput.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        e.preventDefault();
        searchMapLocation();
      }
    });
    mapSearchInput.addEventListener('input', () => {
      if (mapSearchClear) {
        mapSearchClear.style.display = mapSearchInput.value ? 'block' : 'none';
      }
    });
  }
  if (mapSearchClear) {
    mapSearchClear.addEventListener('click', () => {
      if (mapSearchInput) {
        mapSearchInput.value = '';
        mapSearchInput.focus();
      }
      mapSearchClear.style.display = 'none';
    });
  }

  const modalGpsBtn = document.getElementById('map-modal-gps-btn');
  if (modalGpsBtn) modalGpsBtn.addEventListener('click', detectModalGPS);

  const confirmMapBtn = document.getElementById('map-modal-confirm-btn');
  if (confirmMapBtn) confirmMapBtn.addEventListener('click', confirmMapLocation);

  const sendBtn = document.getElementById('send-whatsapp-order-btn');
  if (sendBtn) sendBtn.addEventListener('click', submitWhatsAppOrder);
}

function renderCartPageItems() {
  const container = document.getElementById('cart-page-items');
  if (!container) return;

  const t = TRANSLATIONS[currentLang];
  const config = getRestaurantConfig();
  const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  const deliveryFee = (currentOrderMode === 'delivery' && cart.length > 0) ? config.deliveryFee : 0;
  const total = subtotal + deliveryFee;

  document.getElementById('cart-page-subtotal').textContent = `${subtotal.toFixed(2)} €`;
  document.getElementById('cart-page-delivery').textContent = `${deliveryFee.toFixed(2)} €`;
  document.getElementById('cart-page-total').textContent = `${total.toFixed(2)} €`;

  if (cart.length === 0) {
    container.innerHTML = `
      <div class="empty-cart-state" style="padding:2rem 1rem;">
        <span style="font-size:3rem; display:block; margin-bottom:0.5rem;">🛍️</span>
        <p style="color:var(--muted-text); font-size:0.95rem;">${t.cart_empty}</p>
      </div>
    `;
    return;
  }

  container.innerHTML = cart.map(item => {
    const name = currentLang === 'fr' ? item.nameFr : item.nameEn;
    const itemTotal = (item.price * item.quantity).toFixed(2);

    return `
      <div class="cart-item-row">
        <img src="${item.image}" alt="${name}" class="cart-item-thumb">
        <div class="cart-item-info">
          <div class="cart-item-title">${name}</div>
          <div class="cart-item-price">${item.price.toFixed(2)} € × ${item.quantity} = ${itemTotal} €</div>
        </div>
        <div class="qty-stepper">
          <button class="qty-btn" onclick="updateItemQty('${item.id}', -1)">-</button>
          <span class="qty-num">${item.quantity}</span>
          <button class="qty-btn" onclick="updateItemQty('${item.id}', 1)">+</button>
        </div>
      </div>
    `;
  }).join('');
}

// -----------------------------------------------------------------------------
// MAP LOCATION PICKER MODAL CONTROLLER
// -----------------------------------------------------------------------------
function openMapPickerModal() {
  const modal = document.getElementById('map-picker-modal');
  if (!modal) return;
  modal.classList.add('open');
  modal.removeAttribute('aria-hidden');

  const latInput = document.getElementById('cust-latitude');
  const lngInput = document.getElementById('cust-longitude');
  const existingLat = latInput ? parseFloat(latInput.value) || 48.8752 : 48.8752;
  const existingLng = lngInput ? parseFloat(lngInput.value) || 2.3551 : 2.3551;
  selectedMapLat = existingLat;
  selectedMapLng = existingLng;

  const existingAddr = document.getElementById('cust-address')?.value.trim();
  if (existingAddr) {
    selectedMapAddress = existingAddr;
    updateMapPreviewText(selectedMapAddress);
  }

  initPickerMap(selectedMapLat, selectedMapLng);

  setTimeout(() => {
    if (pickerMapInstance) {
      pickerMapInstance.invalidateSize();
      pickerMapInstance.setView([selectedMapLat, selectedMapLng], 15);
    }
  }, 250);
}

function closeMapPickerModal() {
  const modal = document.getElementById('map-picker-modal');
  if (modal) {
    modal.classList.remove('open');
    modal.setAttribute('aria-hidden', 'true');
  }
}

function initPickerMap(lat, lng) {
  const mapElement = document.getElementById('picker-leaflet-map');
  if (!mapElement || typeof L === 'undefined') return;

  if (!pickerMapInstance) {
    pickerMapInstance = L.map('picker-leaflet-map').setView([lat, lng], 15);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; OpenStreetMap'
    }).addTo(pickerMapInstance);

    pickerMapMarker = L.marker([lat, lng], { draggable: true }).addTo(pickerMapInstance);

    pickerMapMarker.on('dragend', (e) => {
      const pos = e.target.getLatLng();
      selectedMapLat = pos.lat;
      selectedMapLng = pos.lng;
      fetchModalReverseGeocode(pos.lat, pos.lng);
    });

    pickerMapInstance.on('click', (e) => {
      pickerMapMarker.setLatLng(e.latlng);
      selectedMapLat = e.latlng.lat;
      selectedMapLng = e.latlng.lng;
      fetchModalReverseGeocode(e.latlng.lat, e.latlng.lng);
    });
  } else {
    pickerMapInstance.setView([lat, lng], 15);
    pickerMapMarker.setLatLng([lat, lng]);
  }

  if (!selectedMapAddress) {
    fetchModalReverseGeocode(lat, lng);
  }
}

function updateMapPreviewText(text, isLoading = false) {
  const previewEl = document.getElementById('map-modal-preview-address');
  if (!previewEl) return;
  if (isLoading) {
    previewEl.innerHTML = `<span class="map-preview-loading">⏳ ${text}</span>`;
  } else {
    previewEl.textContent = text;
  }
}

async function fetchModalReverseGeocode(lat, lng) {
  updateMapPreviewText(currentLang === 'fr' ? "Chargement de l'adresse..." : "Loading address...", true);
  try {
    const res = await fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}`);
    const data = await res.json();
    if (data && data.display_name) {
      selectedMapAddress = data.display_name;
      updateMapPreviewText(selectedMapAddress);
    } else {
      selectedMapAddress = `${lat.toFixed(6)}, ${lng.toFixed(6)}`;
      updateMapPreviewText(selectedMapAddress);
    }
  } catch (err) {
    console.error("Reverse geocoding error:", err);
    selectedMapAddress = `${lat.toFixed(6)}, ${lng.toFixed(6)}`;
    updateMapPreviewText(selectedMapAddress);
  }
}

async function searchMapLocation() {
  const input = document.getElementById('map-modal-search-input');
  if (!input) return;
  const query = input.value.trim();
  if (!query) return;

  const btn = document.getElementById('map-modal-search-btn');
  const originalHtml = btn ? btn.innerHTML : '';
  if (btn) btn.innerHTML = `<span>⏳</span>`;

  try {
    const res = await fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(query)}&limit=1`);
    const data = await res.json();
    if (data && data.length > 0) {
      const item = data[0];
      const lat = parseFloat(item.lat);
      const lon = parseFloat(item.lon);
      selectedMapLat = lat;
      selectedMapLng = lon;
      selectedMapAddress = item.display_name;

      if (pickerMapInstance && pickerMapMarker) {
        pickerMapInstance.setView([lat, lon], 16);
        pickerMapMarker.setLatLng([lat, lon]);
      }
      updateMapPreviewText(selectedMapAddress);
    } else {
      alert(currentLang === 'fr' 
        ? "Adresse introuvable. Essayez avec le nom d'une rue, d'un quartier ou d'une ville." 
        : "Address not found. Try entering a street, neighborhood, or city name.");
    }
  } catch (err) {
    console.error("Geocoding search error:", err);
    alert(currentLang === 'fr' ? "Erreur lors de la recherche." : "Search error.");
  } finally {
    if (btn) btn.innerHTML = originalHtml;
  }
}

function detectModalGPS() {
  if (!navigator.geolocation) {
    alert("Geolocation is not supported by your browser.");
    return;
  }

  const btn = document.getElementById('map-modal-gps-btn');
  const origText = btn ? btn.innerHTML : '';
  if (btn) btn.innerHTML = '⏳';

  navigator.geolocation.getCurrentPosition(
    (pos) => {
      const lat = pos.coords.latitude;
      const lng = pos.coords.longitude;
      selectedMapLat = lat;
      selectedMapLng = lng;

      if (pickerMapInstance && pickerMapMarker) {
        pickerMapInstance.setView([lat, lng], 16);
        pickerMapMarker.setLatLng([lat, lng]);
      }
      fetchModalReverseGeocode(lat, lng);
      if (btn) btn.innerHTML = origText;
    },
    (err) => {
      alert("GPS detection failed: " + err.message);
      if (btn) btn.innerHTML = origText;
    },
    { enableHighAccuracy: true, timeout: 10000 }
  );
}

function detectDirectGPS() {
  if (!navigator.geolocation) {
    alert("Geolocation is not supported by your browser.");
    return;
  }

  const gpsBtn = document.getElementById('quick-gps-btn');
  const originalText = gpsBtn ? gpsBtn.innerHTML : '';
  if (gpsBtn) {
    gpsBtn.innerHTML = `<span>⏳</span> <span>${currentLang === 'fr' ? 'Localisation...' : 'Locating...'}</span>`;
  }

  navigator.geolocation.getCurrentPosition(
    async (pos) => {
      const lat = pos.coords.latitude;
      const lng = pos.coords.longitude;
      selectedMapLat = lat;
      selectedMapLng = lng;

      const latEl = document.getElementById('cust-latitude');
      const lngEl = document.getElementById('cust-longitude');
      if (latEl) latEl.value = lat.toFixed(6);
      if (lngEl) lngEl.value = lng.toFixed(6);

      try {
        const res = await fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}`);
        const data = await res.json();
        if (data && data.display_name) {
          selectedMapAddress = data.display_name;
          const addrEl = document.getElementById('cust-address');
          if (addrEl) {
            addrEl.value = data.display_name;
            addrEl.style.transition = 'all 0.3s ease';
            addrEl.style.borderColor = 'var(--primary-deep)';
            addrEl.style.boxShadow = '0 0 0 4px rgba(7, 91, 47, 0.2)';
            setTimeout(() => {
              addrEl.style.borderColor = '';
              addrEl.style.boxShadow = '';
            }, 1500);
          }
        }
      } catch (err) {
        console.error("Direct GPS reverse geocode error:", err);
      }

      if (gpsBtn) gpsBtn.innerHTML = originalText;
    },
    (err) => {
      alert("GPS detection failed: " + err.message);
      if (gpsBtn) gpsBtn.innerHTML = originalText;
    },
    { enableHighAccuracy: true, timeout: 10000 }
  );
}

function confirmMapLocation() {
  const addrInput = document.getElementById('cust-address');
  const latInput = document.getElementById('cust-latitude');
  const lngInput = document.getElementById('cust-longitude');

  if (addrInput && selectedMapAddress) {
    addrInput.value = selectedMapAddress;
    addrInput.style.transition = 'all 0.3s ease';
    addrInput.style.borderColor = 'var(--primary-deep)';
    addrInput.style.boxShadow = '0 0 0 4px rgba(7, 91, 47, 0.2)';
    setTimeout(() => {
      addrInput.style.borderColor = '';
      addrInput.style.boxShadow = '';
    }, 1500);
  }

  if (latInput) latInput.value = selectedMapLat.toFixed(6);
  if (lngInput) lngInput.value = selectedMapLng.toFixed(6);

  closeMapPickerModal();
}

function generateOrderReference() {
  const now = new Date();
  const y = now.getFullYear();
  const m = String(now.getMonth() + 1).padStart(2, '0');
  const d = String(now.getDate()).padStart(2, '0');
  const rand = Math.floor(100 + Math.random() * 900);
  return `ND-${y}${m}${d}-${rand}`;
}

function submitWhatsAppOrder() {
  if (cart.length === 0) {
    alert(currentLang === 'fr' ? "Votre panier est vide." : "Your cart is empty.");
    return;
  }

  const config = getRestaurantConfig();
  const name = document.getElementById('cust-name').value.trim();
  const phone = document.getElementById('cust-phone').value.trim();
  const address = document.getElementById('cust-address')?.value.trim() || '';
  const time = document.getElementById('cust-time')?.value.trim() || 'Dès que possible';
  const notes = document.getElementById('cust-notes')?.value.trim() || '';
  const lat = document.getElementById('cust-latitude')?.value;
  const lng = document.getElementById('cust-longitude')?.value;

  if (!name || !phone) {
    alert(currentLang === 'fr' ? "Veuillez renseigner votre nom et numéro de téléphone." : "Please provide your name and phone number.");
    return;
  }

  if (currentOrderMode === 'delivery' && !address) {
    alert(currentLang === 'fr' ? "Veuillez renseigner votre adresse de livraison." : "Please provide your delivery address.");
    return;
  }

  const orderId = generateOrderReference();
  const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  const deliveryFee = currentOrderMode === 'delivery' ? config.deliveryFee : 0;
  const total = subtotal + deliveryFee;

  let msg = `🍽️ *NOUVELLE COMMANDE NANDI DELICES*\n`;
  msg += `📋 *Réf :* ${orderId}\n`;
  msg += `👤 *Client :* ${name}\n`;
  msg += `📞 *Téléphone :* ${phone}\n`;
  msg += `🛵 *Mode :* ${currentOrderMode === 'delivery' ? 'Livraison à domicile' : 'Retrait sur place (Click & Collect)'}\n`;

  if (currentOrderMode === 'delivery') {
    msg += `📍 *Adresse :* ${address}\n`;
    if (lat && lng) {
      msg += `🗺️ *Localisation GPS :* https://maps.google.com/?q=${lat},${lng}\n`;
    }
  }

  msg += `⏰ *Horaire souhaité :* ${time}\n`;
  if (notes) msg += `📝 *Notes :* ${notes}\n`;

  msg += `\n🛒 *DÉTAIL DU PANIER :*\n`;
  cart.forEach(item => {
    const itemTotal = (item.price * item.quantity).toFixed(2);
    msg += `• ${item.quantity}x ${item.nameFr} (${itemTotal} €)\n`;
  });

  msg += `\n💰 *Sous-total :* ${subtotal.toFixed(2)} €\n`;
  if (currentOrderMode === 'delivery') {
    msg += `🛵 *Frais de livraison :* ${deliveryFee.toFixed(2)} €\n`;
  }
  msg += `💳 *TOTAL À PAYER :* ${total.toFixed(2)} €\n`;
  msg += `\nMerci pour votre commande chez Nandi Delices ! 🙏`;

  const waUrl = `https://wa.me/${config.whatsappNumber}?text=${encodeURIComponent(msg)}`;

  cart = [];
  localStorage.removeItem('nandi_cart');
  updateCartBadge();
  renderCartPageItems();

  window.open(waUrl, '_blank');
}

// =============================================================================
// 4. ABOUT PAGE CONTROLLER
// =============================================================================
function initAboutPage() {
  const config = getRestaurantConfig();
  const hoursVal = document.getElementById('about-hours-val');
  const addrVal = document.getElementById('about-address-display');

  if (hoursVal) hoursVal.textContent = config.openingHours;
  if (addrVal) addrVal.textContent = config.address;

  const mapEl = document.getElementById('about-map');
  if (mapEl && typeof L !== 'undefined') {
    const defaultLat = 48.8752;
    const defaultLng = 2.3551;
    const aboutMap = L.map('about-map').setView([defaultLat, defaultLng], 15);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; OpenStreetMap'
    }).addTo(aboutMap);

    L.marker([defaultLat, defaultLng])
      .addTo(aboutMap)
      .bindPopup(`<b>${config.name}</b><br>${config.address}`)
      .openPopup();
  }
}

// =============================================================================
// GLOBAL EVENTS & SETTINGS MODAL
// =============================================================================
function initGlobalEvents() {
  const settingsModal = document.getElementById('settings-modal');
  const settingsBtn = document.getElementById('footer-settings-btn');
  const closeSettingsBtn = document.getElementById('close-settings-modal-btn');
  const saveSettingsBtn = document.getElementById('save-settings-btn');

  if (settingsBtn && settingsModal) {
    settingsBtn.addEventListener('click', () => {
      const config = getRestaurantConfig();
      document.getElementById('settings-wa-number').value = config.whatsappNumber;
      document.getElementById('settings-address').value = config.address;
      document.getElementById('settings-hours').value = config.openingHours;
      if (config.isOpenNow) {
        document.getElementById('settings-status-open').checked = true;
      } else {
        document.getElementById('settings-status-closed').checked = true;
      }
      settingsModal.classList.add('open');
    });
  }

  if (closeSettingsBtn && settingsModal) {
    closeSettingsBtn.addEventListener('click', () => settingsModal.classList.remove('open'));
  }

  if (saveSettingsBtn && settingsModal) {
    saveSettingsBtn.addEventListener('click', () => {
      const isOpen = document.getElementById('settings-status-open').checked;
      const wa = document.getElementById('settings-wa-number').value.trim();
      const addr = document.getElementById('settings-address').value.trim();
      const hours = document.getElementById('settings-hours').value.trim();

      saveRestaurantConfig({
        isOpenNow: isOpen,
        whatsappNumber: wa,
        address: addr,
        openingHours: hours
      });

      initRestaurantConfig();
      settingsModal.classList.remove('open');
      alert(currentLang === 'fr' ? "Réglages enregistrés avec succès !" : "Settings saved successfully!");
    });
  }
}
