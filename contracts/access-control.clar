;; ----------------------------------------------------------------------
;; Contract: access-control.clar
;; Purpose: Manage access to on-chain or off-chain resources via permissions.
;; ----------------------------------------------------------------------

;; --- Constants ---
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-ALREADY-GRANTED (err u101))
(define-constant ERR-NOT-IN-LIST (err u102))
(define-constant ERR-CANNOT-RENOUNCE (err u103))

;; --- Data Variables ---
(define-data-var contract-owner principal tx-sender)

;; --- Access Map ---
;; Maps a principal to a boolean (true = has access)
(define-map access-list principal bool)

;; ----------------------------------------------------------------------
;; Grant access to a principal (admin only)
;; ----------------------------------------------------------------------
(define-public (grant-access (user principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    (asserts! (not (default-to false (map-get? access-list user))) ERR-ALREADY-GRANTED)
    (map-set access-list user true)
    (print { action: "grant-access", granted-to: user })
    (ok true)
  )
)

;; ----------------------------------------------------------------------
;; Revoke access from a principal (admin only)
;; ----------------------------------------------------------------------
(define-public (revoke-access (user principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    (asserts! (default-to false (map-get? access-list user)) ERR-NOT-IN-LIST)
    (map-delete access-list user)
    (print { action: "revoke-access", revoked-from: user })
    (ok true)
  )
)

;; ----------------------------------------------------------------------
;; Public function: Renounce your own access
;; ----------------------------------------------------------------------
(define-public (renounce-access)
  (begin
    (asserts! (is-eq (var-get contract-owner) tx-sender) ERR-CANNOT-RENOUNCE)
    (if (default-to false (map-get? access-list tx-sender))
        (begin
          (map-delete access-list tx-sender)
          (print { action: "renounce-access", user: tx-sender })
          (ok true)
        )
        ERR-NOT-IN-LIST
    )
  )
)

;; ----------------------------------------------------------------------
;; Read-only: Check if a principal has access
;; ----------------------------------------------------------------------
(define-read-only (has-access (user principal))
  (ok (default-to false (map-get? access-list user)))
)

;; ----------------------------------------------------------------------
;; Read-only: Get contract owner
;; ----------------------------------------------------------------------
(define-read-only (get-owner)
  (ok (var-get contract-owner))
)
