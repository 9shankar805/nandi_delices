# Nandi Delices — Application Requirements

## 1. Project Overview

Build a mobile-first restaurant ordering application for **Nandi Delices – Home Style Food**.

The visual identity must follow the supplied menu and logo:
- Black, red, yellow, and green brand palette.
- Circular Nandi Delices logo with the dodo/bird mascot.
- Warm food photography.
- Cream/off-white content surfaces.
- Rounded cards and section headers.
- Strong, readable typography.
- French + English food names.
- Euro currency.

The primary ordering mechanism is **direct WhatsApp navigation**, similar to a WhatsApp-store ordering experience.

## 2. Core Ordering Concept

The application must NOT use WhatsApp Business API for the initial version.

Customer flow:

1. Open app.
2. Browse menu.
3. Add items to cart.
4. Review cart.
5. Enter customer/order information.
6. Tap **Place Order on WhatsApp**.
7. App creates a pre-filled WhatsApp message.
8. App opens WhatsApp directly using `wa.me`.
9. Customer reviews the message and taps Send.

The restaurant's WhatsApp number is configurable in one central setting.

## 3. Customer Features

### Home
- Nandi Delices logo.
- Restaurant name.
- Short tagline: "Home Style Food".
- Featured categories.
- Popular/recommended items.
- CTA: "Order Now".
- WhatsApp-themed ordering cue without copying WhatsApp branding excessively.

### Menu
Categories:
- Snacks / Starters
- Plats principaux / Main Dishes
- Spécial / Sur commande
- Desserts

Each item:
- Food image.
- French name.
- English name.
- Price.
- Unit such as `/ pièce`, `/ 100g`, `/ portion`, `/ box`.
- Add button.
- Quantity control once added.

### Cart
- Item image.
- French + English name.
- Quantity +/-.
- Unit price.
- Line total.
- Remove item.
- Order subtotal.
- Optional delivery fee.
- Grand total.
- Continue to checkout.

### Checkout
Fields:
- Customer name — required.
- Phone number — required.
- Order type — Pickup / Delivery.
- Delivery address — required only for Delivery.
- Optional note.
- Optional preferred pickup/delivery time.
- Order summary.
- Total.
- "Place Order on WhatsApp" button.

### WhatsApp Order
Generate a readable message containing:
- Restaurant name.
- Order reference generated locally, e.g. ND-20261003-001.
- Customer details.
- Order type.
- Address if delivery.
- Items with quantities.
- Prices.
- Subtotal.
- Delivery fee if applicable.
- Total.
- Customer note.

Then navigate to:

`https://wa.me/<RESTAURANT_WHATSAPP_NUMBER>?text=<URL_ENCODED_MESSAGE>`

No automatic WhatsApp API message is required.

## 4. Restaurant Configuration

Store these values in one configuration file:
- Restaurant name.
- WhatsApp number in international format.
- Currency.
- Delivery fee.
- Restaurant address.
- Opening hours.
- Social/contact links.

Do not hard-code the WhatsApp number throughout the application.

## 5. Offline/Low-Backend First Version

The initial version can operate without a custom backend because the final order is sent through WhatsApp.

Menu data should be local JSON/static data.

Recommended future upgrade:
- Backend database.
- Admin panel.
- Order history.
- Online payment.
- Customer accounts.
- Push notifications.

## 6. UX Requirements

- Mobile-first.
- Fast loading.
- Clear food photography.
- Large touch targets.
- Sticky cart summary/button where appropriate.
- Avoid unnecessary registration before ordering.
- Minimum steps from menu to WhatsApp.
- Preserve cart while navigating between categories.
- Empty cart state.
- Validation for required checkout fields.
- Friendly success/transition message before opening WhatsApp.
- If WhatsApp is unavailable, show a fallback message with the restaurant number.

## 7. Branding

Use the supplied `reference_logo.jpeg` and `reference_menu.jpeg` as visual references.

Primary visual direction:
- Deep green
- Golden yellow
- Black
- Warm red
- Cream background
- White cards
- Subtle shadows
- Rounded corners

Do not redesign the brand into a generic food-delivery app. It should feel like the supplied Nandi Delices menu translated into a modern mobile application.

## 8. Accessibility

- Text must remain readable against backgrounds.
- Buttons need clear labels.
- Images need useful alt text.
- Do not rely only on color to communicate status.
- Touch targets should be approximately 44px or larger.
