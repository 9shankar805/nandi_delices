# Nandi Delices — UI/UX Specification

## 1. Design Language

The UI should feel like the supplied printed menu:
- Cream paper-like background.
- Strong green category accents.
- Golden yellow highlights.
- Red accents for food/brand emphasis.
- Black headings.
- White/cream cards.
- Rounded 16–20px corners.
- Food images with rounded corners.
- Thin borders.
- Soft shadows.
- Generous spacing.

## 2. Suggested Color Tokens

```text
Primary Green: #087A3D
Deep Green:    #075B2F
Gold:          #F4C400
Warm Red:      #D71920
Black:         #111111
Cream:         #FFF9EC
White:         #FFFFFF
Muted Text:    #6B6B6B
Border:        #E4DDCC
```

Use these as starting tokens; adjust against the supplied logo/menu during implementation.

## 3. Typography

Recommended:
- Display/brand: bold rounded/script style where appropriate.
- Main headings: bold sans-serif.
- Food names: semibold.
- English descriptions: regular.
- Price: bold.
- Body: clean sans-serif.

French and English should be visually balanced.

## 4. Home Screen

Structure:

```text
┌──────────────────────────┐
│ Nandi Delices       ☰    │
│                          │
│ [Large Logo / Hero]      │
│ Home Style Food          │
│                          │
│ [ ORDER NOW ]            │
│                          │
│ Categories               │
│ [Starters] [Main Dishes] │
│ [Special]  [Desserts]    │
│                          │
│ Popular Dishes           │
│ ┌──────┐ ┌──────┐        │
│ │Food  │ │Food  │        │
│ │Name  │ │Name  │        │
│ │€3.80 │ │€3.50 │        │
│ └──────┘ └──────┘        │
└──────────────────────────┘
```

## 5. Menu Screen

Header:
- Back.
- "Menu".
- Cart icon/count.

Category tabs:
- Snacks
- Main Dishes
- Special
- Desserts

Food card:
```text
┌──────────────────────────┐
│ [Food Image]             │
│ Chicken Curry            │
│ Curry poulet             │
│ €3.80 / 100g             │
│                    [ + ] │
└──────────────────────────┘
```

## 6. Cart Screen

```text
My Cart

[image] Chicken Curry
        €3.80 / 100g
        [-] 2 [+]             €7.60

[image] Vegetable Samosas
        €1 / pièce
        [-] 2 [+]             €2.00

─────────────────────────────
Subtotal                    €9.60
Delivery                     €2.00
TOTAL                      €11.60

[ Proceed to Checkout ]
```

## 7. Checkout Screen

Sections:
1. Customer information.
2. Order type.
3. Address.
4. Notes.
5. Order summary.
6. Total.
7. WhatsApp CTA.

Primary CTA:
**Place Order on WhatsApp**

Use green as the main action color.

## 8. WhatsApp CTA

Button:
- WhatsApp-style icon.
- Text: "Place Order on WhatsApp".
- Full width.
- High contrast.
- Large touch target.

Do not show a fake "order confirmed" state before WhatsApp is opened/sent.

Recommended wording after tapping:
"Opening WhatsApp with your order..."

## 9. Order Success/Transition

After launching WhatsApp, if the app returns:
- Show "Order message prepared in WhatsApp."
- Explain that the customer must tap Send in WhatsApp.

## 10. Responsive Design

Primary target:
- Mobile 320px–430px.
Secondary:
- Tablet.
- Desktop/web if required.

On desktop:
- Center the mobile-style content inside a wider restaurant ordering layout.
- Use a two-column menu where appropriate.
- Keep cart accessible.

## 11. Image Rules

Use the supplied food/menu images as references.

Food images should:
- Be consistent aspect ratio.
- Have rounded corners.
- Avoid stretching.
- Use object-fit cover.
- Load efficiently.

## 12. Brand Logo

Use the supplied Nandi Delices logo prominently on:
- Splash/landing.
- Home header/hero.
- About/contact.
- Optional checkout confirmation.

Do not distort the circular logo.
