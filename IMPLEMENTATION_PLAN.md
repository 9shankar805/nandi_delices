# Nandi Delices — Implementation Plan

## Phase 1 — UI

Build:
1. Splash/landing.
2. Home.
3. Menu categories.
4. Food detail/card.
5. Cart.
6. Checkout.
7. WhatsApp handoff.
8. Contact/About.

## Phase 2 — Menu Data

Create local menu JSON and assets.

The supplied menu contains:
- 12 Snacks / Starters.
- 21 Main Dishes.
- 1 Special / On Order.
- 3 Desserts.
- 37 total menu entries.

Use the supplied menu image as the source of truth for the displayed names/prices and verify each entry manually during implementation.

## Phase 3 — Cart Logic

Implement:
- Add.
- Remove.
- Increase quantity.
- Decrease quantity.
- Clear cart.
- Persistent in-memory cart during navigation.
- Subtotal calculation.

## Phase 4 — Checkout

Implement:
- Form validation.
- Delivery/pickup selection.
- Conditional address.
- Notes.
- Total calculation.
- Order reference generation.

## Phase 5 — WhatsApp

Implement:

```text
const message = buildOrderMessage(order);
const url =
  "https://wa.me/" +
  restaurantWhatsappNumber +
  "?text=" +
  encodeURIComponent(message);
```

Open the URL using the platform's supported external-link mechanism.

Important:
- Do not send automatically through an API.
- WhatsApp itself handles the final Send action.
- The app should clearly tell the customer that they need to press Send.

## Phase 6 — Testing

Test:
- Empty cart.
- One item.
- Multiple items.
- Quantity changes.
- Delivery with address.
- Pickup without address.
- Missing name.
- Missing phone.
- Special characters in customer name/note.
- French accents.
- Long order with many items.
- WhatsApp installed.
- WhatsApp unavailable.
- Android.
- iOS.
- Mobile web if applicable.

## Phase 7 — Future Backend

Only add a backend if required for:
- Admin dashboard.
- Central menu management.
- Order database.
- Order history.
- Analytics.
- Multi-device restaurant staff.
- Customer accounts.

The WhatsApp handoff can remain independent of the backend.

## Development Principle

Keep the first version simple:

Menu → Cart → Checkout → WhatsApp

Do not add login, payment gateway, delivery tracking, or complex backend functionality unless specifically required.
