# E-commerce Conversion & Revenue Lifecycle Analysis

## Project Overview
This project is a deep dive into e-commerce unit economics and user behavior. Moving beyond basic querying, I performed a **Drop-off Analysis** to pinpoint friction in the 5-stage checkout funnel and an **Attribution Analysis** to determine the ROI of different marketing channels.

---

## Executive Summary: The "So What?"
*   **The Bottleneck:** The highest friction point is **View-to-Cart (32%)**. Once a user adds to cart, the technical flow is nearly perfect (93% Payment-to-Purchase conversion).
*   **The Growth Lever:** Email marketing out-converts Social Media by **5x** (32% vs 6%). 
*   **Efficiency:** The average customer velocity (First View to Purchase) is **24.03 minutes**.

---

## Tech Stack & Skills
*   **SQL (MySQL):** CTEs, Time-Series Analysis (`TIMESTAMPDIFF`), Conditional Aggregations.
*   **Financial Safeguards:** Implemented `COALESCE` and `NULLIF` to ensure zero-division errors don't crash BI reporting.
*   **Business Intelligence:** Funnel Leakage Mapping, Unit Economics (AOV, RPV).

---

## Strategic Business Recommendations

### 1. Marketing Optimization (ROI)
*   **Insight:** Social Media drives 30% of traffic but has the lowest conversion efficiency.
*   **Action:** Pivot social spend from "Traffic" objectives to "Retargeting." Redirect the primary budget into **Email Capture** to feed our highest-converting channel (Email).

### 2. Product & UX Strategy
*   **Insight:** The checkout flow (Stage 3-5) has an 80%+ success rate.
*   **Action:** **Do not redesign the checkout page.** The friction is at the top of the funnel (Discovery/Intent). Focus on product page social proof and "Add to Cart" incentives instead.

### 3. Financial Guardrails
*   **Insight:** Average Order Value (AOV) is **$108.16**.
*   **Action:** Set a strict Customer Acquisition Cost (CAC) limit of $35. Any acquisition cost higher than this on low-converting channels like Social is a net loss for the business.

---

## Project Structure
*   **Analysis Script:** [View Full SQL Script](ecommerce_funnel_analysis.sql)
*   **Key Metrics:** Conversion Rates, AOV, RPV, and Customer Velocity.

---

## 👤 Author
**Kaone Edward**
*   [LinkedIn](https://www.linkedin.com)
*   [GitHub](https://github.com)
