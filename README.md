## About

An android mobile app to enable Pfeiffer users to update the status of 
the works that they currently handling.

## Version


## Building
Steps to build apk:
1) Enter "cd [project]".
2) Run "flutter build apk --split-per-abi". 


## Running


## Requirements

- Login page
- Home screen with Quotations, Orders, Job Cards, Expenses as 4 buttons vertically aligned
- Clicking on Quotations, will take the user to Quotations listing screen

### Quotations listing screen

- Listing of quotations is done via ReST API call:
```agsl
GET /api/v1/quotations
```
Response will be a json:

```json
{
    "metadata": {
        "resultCount": 2
    },
    "results": [
        { 
            "referenceNumber": "DQ20240001", 
            "status": { 
                "id": 0, 
                "label": "Open"
            }
        },
        { 
            "referenceNumber": "DQ20240012", 
            "status": { 
                "id": 5, 
                "label": "Order Received"
            }
        }
    ]
}
```

- Each Quotation box will contain a Quotation Reference number (e.g. DQ20240001, IQ20240012 etc.), and Status of that quotation
- Clicking on that quotation box, will show the selection of statuses:
  - Open (value is 0)
  - Order Created (value is 1)
  - Dropped/Cancelled (value is 2)
  - Re-floated (value is 3)
  - Lost (value is 4)
  - Order Received (value is 5)
- User can select one of those statuses, and once selected, it will update the status, by making a POST call as given below:

```
POST /api/v1/quotations/{quotationReference}/status
```
with the request body:

```json
{
    "id": 1 
}
```


### Orders listing screen

Orders listing is also similar to Quotations, except that the statuses will be different:
- Open (value is 0)
- Shipped (value is 1)
- Cancelled (value is 2)
- On-Hold (value is 3)

API call to get the list of orders:

```agsl
GET /api/v1/orders
```

API call to post status update:

```
POST /api/v1/orders/{orderReference}/status
```
with the request body:

```json
{
    "id": 1 
}
```
