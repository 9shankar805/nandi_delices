# Nandi Delices — Application Workflow

## A. Main Customer Workflow

```text
APP OPEN
   ↓
HOME
   ↓
MENU
   ↓
SELECT CATEGORY
   ↓
SELECT FOOD
   ↓
ADD TO CART
   ↓
CART
   ↓
CHECKOUT
   ↓
CUSTOMER DETAILS
   ↓
ORDER REVIEW
   ↓
PLACE ORDER ON WHATSAPP
   ↓
GENERATE ORDER MESSAGE
   ↓
OPEN WHATSAPP
   ↓
CUSTOMER REVIEWS MESSAGE
   ↓
CUSTOMER TAPS SEND
   ↓
RESTAURANT RECEIVES ORDER
```

## B. Navigation

```text
Home
 ├── Menu
 │    ├── Snacks / Starters
 │    ├── Main Dishes
 │    ├── Special / On Order
 │    └── Desserts
 ├── Cart
 ├── About
 └── Contact
```

Bottom navigation recommendation:
- Home
- Menu
- Cart
- Contact

## C. Add-to-Cart Workflow

1. Customer taps Add.
2. Item is added with quantity 1.
3. Cart count updates.
4. Cart subtotal updates.
5. Customer can increase/decrease quantity.
6. Quantity reaching zero removes the item.
7. Cart remains available across menu navigation.

## D. Checkout Workflow

Required:
- Name.
- Phone.
- Order type.

Conditional:
- Address if Delivery.

Optional:
- Note.
- Preferred time.

Before WhatsApp:
- Validate fields.
- Calculate totals again.
- Generate order reference.
- Create WhatsApp text.

## E. WhatsApp Message Workflow

Example generated message:

```text
🍽️ NANDI DELICES
HOME STYLE FOOD

Order: ND-20261003-001

Customer: Shankar Yadav
Phone: +97798XXXXXXXX
Order Type: Delivery
Address: Kathmandu

ITEMS
2 × Chicken Curry — €7.60
1 × Vegetable Samosas — €1.00
1 × Coconut Ball — €1.00

Subtotal: €9.60
Delivery: €2.00
TOTAL: €11.60

Note: Please make it mildly spicy.

Thank you!
```

The message must be URL encoded before being added to the WhatsApp link.

## F. Error/Fallback Workflow

### WhatsApp unavailable
Show:
"WhatsApp could not be opened. Please contact Nandi Delices directly."

Buttons:
- Try WhatsApp Again
- Copy Order Text
- Call Restaurant

### Empty Cart
Show:
"Your cart is empty."
CTA:
"Browse Menu"

### Invalid Checkout
Keep entered values and highlight only the missing/invalid fields.

## G. Future Admin Workflow

This is optional for version 1.

```text
ADMIN LOGIN
   ↓
DASHBOARD
   ├── Menu Management
   ├── Orders
   ├── Categories
   ├── Restaurant Settings
   └── WhatsApp Number
```

If a backend is added later, WhatsApp remains the customer communication channel unless a different requirement is introduced.
