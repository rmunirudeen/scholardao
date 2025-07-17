#  Scholar Freelance DAO – Clarity Smart Contract

A unified smart contract for decentralized freelance work, AI-powered grading, reputation NFTs, DAO-based governance, and escrow management on the Stacks blockchain.

##  Overview

**Scholar Freelance DAO** is designed to streamline and decentralize the relationship between clients and freelancers, enhanced by AI feedback, trust-based staking, and transparent job fulfillment using milestone-based escrows. Reputation is tracked through NFT-backed metrics to encourage quality and accountability.

---

##  Features

###  User Management
- `register`: Allows users to register with a role (e.g., "client", "freelancer") and profile URI.
- `stake-tokens`: Users can stake STX tokens to increase trust and eligibility.
- Trust and reputation data is tracked per user, including role, profile, stake, and a trust score.
- Total user count tracked via `total-users`.

###  Job Management
- `create-job`: Clients create milestone-based jobs and lock funds into escrow.
- `submit-milestone`: Freelancers submit work linked to a specific milestone.
- `oracle-grade`: AI or oracle submits a numeric score for submitted work.
- `submit-ai-feedback`: Store strengths and improvement suggestions for AI-graded work.
- Jobs are stored with metadata like client, freelancer, milestone list, status, and total payment.

###  Reputation NFTs
- `rep-nft` map tracks user performance:
  - `score`, `wins`, `fails`, and `disputes` for reputation scoring.

###  Escrow & Penalty Logic
- Funds are locked upon job creation via `stx-transfer?`.
- Future penalty/reward logic can be implemented using `rep-nft` and AI scoring.
- `get-element-at`: Utility to retrieve specific milestone payments from job data.

---

##  Contract Purpose

This contract enables:
- **Decentralized freelance platforms** with milestone tracking.
- **Automated AI grading** for submitted work.
- **NFT-based reputation systems** for transparent performance metrics.
- **DAO voting & governance** (to be implemented separately).
- **Escrow system** for secure fund handling.
