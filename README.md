A Clarity smart contract to manage access permissions for on-chain or off-chain resources via a simple permission system.

## Overview

This contract enables an owner to grant or revoke access to different principals, allowing controlled interaction with resources. Users can also renounce their access, except for the contract owner who cannot renounce.

---

## Features

- **Owner-controlled access management**: Only the contract owner can grant or revoke access.
- **Self-renouncement**: Principals can renounce their own access permissions.
- **Access queries**: Check if a principal has access and retrieve the contract owner.
- **Error handling**: Prevents unauthorized access changes, duplicate grants, and invalid revocations.

---

## Contract Functions

### Public Functions

- `grant-access(user: principal) -> (response bool uint)`
  - Grants access to a specified principal.
  - Only callable by the contract owner.
  - Errors if user already has access or caller is unauthorized.

- `revoke-access(user: principal) -> (response bool uint)`
  - Revokes access from a specified principal.
  - Only callable by the contract owner.
  - Errors if user does not have access or caller is unauthorized.

- `renounce-access() -> (response bool uint)`
  - Allows a principal to renounce their own access.
  - The contract owner cannot renounce access.
  - Errors if caller does not have access.

### Read-only Functions

- `has-access(user: principal) -> (response bool uint)`
  - Returns `true` if the specified principal has access, else `false`.

- `get-owner() -> (response principal uint)`
  - Returns the principal that owns the contract.

---

## Error Codes

| Error Code     | Description                     |
|----------------|--------------------------------|
| `ERR-NOT-AUTHORIZED` (100) | Caller is not the contract owner |
| `ERR-ALREADY-GRANTED` (101) | User already has access          |
| `ERR-NOT-IN-LIST` (102)     | User does not have access         |
| `ERR-CANNOT-RENOUNCE` (103) | Contract owner cannot renounce   |





This project is licensed under the MIT License.
