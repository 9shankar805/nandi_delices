# Nandi Delices — Data Model

Version 1 can use local JSON/static data.

## Menu Item

```json
{
  "id": "chicken-curry",
  "category": "main-dishes",
  "nameFr": "Curry poulet",
  "nameEn": "Chicken Curry",
  "price": 3.80,
  "unit": "100g",
  "image": "assets/menu/chicken-curry.webp",
  "available": true
}
```

## Cart Item

```json
{
  "itemId": "chicken-curry",
  "quantity": 2,
  "unitPrice": 3.80
}
```

## Checkout

```json
{
  "customerName": "Customer Name",
  "phone": "+977XXXXXXXXXX",
  "orderType": "delivery",
  "address": "Customer Address",
  "note": "Optional note",
  "preferredTime": "Optional",
  "items": [],
  "subtotal": 9.60,
  "deliveryFee": 2.00,
  "total": 11.60
}
```

## Restaurant Config

```json
{
  "name": "Nandi Delices",
  "tagline": "Home Style Food",
  "whatsappNumber": "COUNTRYCODE_NUMBER",
  "currency": "EUR",
  "deliveryFee": 0,
  "phone": "",
  "address": "",
  "openingHours": ""
}
```

## Important

The WhatsApp number should be stored in international format without spaces or symbols when used in `wa.me`.

Example:

```text
33123456789
```

not:

```text
+33 1 23 45 67 89
```

## Order Total

```text
subtotal = sum(item.price × item.quantity)

total = subtotal + deliveryFee
```

The frontend must calculate and display the total consistently before generating the WhatsApp message.
