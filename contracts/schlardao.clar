;; ==========================
;; Contract: scholar-freelance-dao.clar
;; Purpose: Unified freelance, AI grading, DAO voting, NFT-based rep, escrow, penalties, referrals
;; ==========================

;; === User Management ===
(define-map users principal
  { role: (string-ascii 16), profile-uri: (string-utf8 256), stake: uint, trust-score: uint })

(define-map rep-nft principal {score: uint, wins: uint, fails: uint, disputes: uint})

(define-data-var total-users uint u0)

(define-public (register (role (string-ascii 16)) (profile-uri (string-utf8 256)))
  (begin
    (map-insert users tx-sender {role: role, profile-uri: profile-uri, stake: u0, trust-score: u50})
    (var-set total-users (+ (var-get total-users) u1))
    (ok true)))

(define-public (stake-tokens (amount uint))
  (let ((transfer-result (stx-transfer? amount tx-sender (as-contract tx-sender))))
    (match transfer-result
      ok-value
        (let ((current (default-to {role: "", profile-uri: u"", stake: u0, trust-score: u0} (map-get? users tx-sender))))
          (map-set users tx-sender (merge current {stake: (+ (get stake current) amount)}))
          (ok true))
      err-value transfer-result)))

;; === Job Management ===
(define-map jobs uint
  { client: principal, freelancer: principal, milestones: (list 10 uint), status: (string-ascii 16), paid: uint })

(define-map submissions (tuple (job-id uint) (ms-id uint)) (tuple (uri (string-utf8 256)) (status (string-ascii 16))))
(define-map ai-scores (tuple (job-id uint) (ms-id uint)) uint)
(define-map ai-feedback (tuple (job-id uint) (ms-id uint))
  { strengths: (string-utf8 256), improvements: (string-utf8 256) })

(define-data-var total-jobs uint u0)

(define-public (create-job (freelancer principal) (milestones (list 10 uint)) (total uint))
  (let ((job-id (+ (var-get total-jobs) u1)))
    (let ((transfer-result (stx-transfer? total tx-sender (as-contract tx-sender))))
      (match transfer-result
        ok-value
          (begin
            (map-insert jobs job-id {client: tx-sender, freelancer: freelancer, milestones: milestones, status: "active", paid: total})
            (var-set total-jobs job-id)
            (ok job-id))
        err-value (err transfer-result)))))

(define-public (submit-milestone (job-id uint) (ms-id uint) (uri (string-utf8 256)))
  (begin
    (map-set submissions {job-id: job-id, ms-id: ms-id} {uri: uri, status: "submitted"})
    (ok true)))

(define-public (oracle-grade (job-id uint) (ms-id uint) (score uint))
  (begin
    (map-set ai-scores {job-id: job-id, ms-id: ms-id} score)
    (ok true)))

(define-public (submit-ai-feedback (job-id uint) (ms-id uint) (strengths (string-utf8 256)) (improvements (string-utf8 256)))
  (begin
    (map-set ai-feedback {job-id: job-id, ms-id: ms-id} {strengths: strengths, improvements: improvements})
    (ok true)))

;; === Escrow & Penalty ===
(define-read-only (get-element-at (lst (list 10 uint)) (i uint))
  (if (or (>= i (len lst)) (< i u0))
      (err u400)
      (match (element-at? lst i)
        value (ok value)
        (err u404))))
