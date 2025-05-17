;; Audit Trail Contract
;; This contract records recovery activities

;; Map to store audit records
(define-map audit-records
  uint
  {
    user: principal,
    action: (string-ascii 20),
    timestamp: uint,
    recovery-id: (optional uint),
    performed-by: principal
  })

;; Counter for audit record IDs
(define-data-var audit-counter uint u0)

;; Record a recovery action
(define-public (record-action
                (user principal)
                (action (string-ascii 20))
                (recovery-id (optional uint)))
  (let ((record-id (var-get audit-counter))
        (block-time (unwrap-panic (get-block-info? time u0))))

    ;; Increment the audit counter
    (var-set audit-counter (+ record-id u1))

    ;; Create the audit record
    (ok (map-set audit-records
                record-id
                {
                  user: user,
                  action: action,
                  timestamp: block-time,
                  recovery-id: recovery-id,
                  performed-by: tx-sender
                }))))

;; Get an audit record
(define-read-only (get-audit-record (record-id uint))
  (map-get? audit-records record-id))

;; Get the total number of audit records
(define-read-only (get-audit-count)
  (var-get audit-counter))
