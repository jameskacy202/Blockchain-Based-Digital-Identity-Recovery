;; Recovery Key Management Contract
;; This contract secures backup access methods for identity recovery

(define-data-var admin principal tx-sender)

;; Map to store recovery keys for users
;; The value is a hash of the recovery key
(define-map recovery-keys principal (string-ascii 64))

;; Error codes
(define-constant err-not-authorized (err u100))
(define-constant err-no-key-found (err u101))

;; Register a recovery key (hash) for a user
(define-public (register-recovery-key (key-hash (string-ascii 64)))
  (ok (map-set recovery-keys tx-sender key-hash)))

;; Verify if a provided key matches the stored hash
(define-public (verify-recovery-key (user principal) (key-hash (string-ascii 64)))
  (let ((stored-hash (map-get? recovery-keys user)))
    (if (and (is-some stored-hash) (is-eq (unwrap-panic stored-hash) key-hash))
        (ok true)
        (err err-no-key-found))))

;; Remove a recovery key
(define-public (remove-recovery-key)
  (ok (map-delete recovery-keys tx-sender)))

;; Check if a user has a recovery key registered
(define-read-only (has-recovery-key (user principal))
  (is-some (map-get? recovery-keys user)))
