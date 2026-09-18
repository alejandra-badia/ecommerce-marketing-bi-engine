# E-Commerce Marketing & LTV Analytics

> **Power BI | DAX | Power Query | Marketing Attribution | E-Commerce Analytics**

## Project Background

Apex Gear Co. is a Direct-to-Consumer (D2C) outdoor & performance e-commerce gear company operating across North America, Europe, and APAC. Over the past 2 quarters, executive leadership allocated a significant budget to scale marketing campaigns across Meta (Facebook/Instagram), Google Ads, and TikTok. While top-line site traffic increased, Gross Revenue remained flat, and overall Customer Acquisition Cost (CAC) surged.

## Overall Objective 
Unify siloed data across ad platforms, web analytics, CRM, and e-commerce orders to evaluate true marketing performance against historical baselines. Specifically, analyze whether the expanded marketing investment increased or eroded overall Marketing ROI, identify performance shortfalls across channels, and establish a data-driven path forward to restore or surpass pre-scaling ROI efficiency through strategic budget reallocation.

---

## Business Problem

To accelerate growth, paid marketing was scaled by 350% from approximately $200K to $700K, when comparing the 6-month baseline period (July 1, 2025 to December 31, 2025) to the marketing campaign scaling period (January 1, 2026 to June 30, 2026). However, it is believed that revenue has remained flat despite the scaling in paid marketing.

## Core Questions Addressed
The analysis addresses three core questions:

1. **Top-Line Realization**
   Did the additional $500K in advertising spend generate incremental revenue?

2. **Channel Quality & Attribution Overlap**
   Did Channel efficiency and return on ad spend increase?

3. **Margin & Customer Quality**
   How did the acquisition push affect customer acquisition quality, AOV, discounting, and product economics?

---

## Approach

To effectively answer the core questions, the 6-month data from the campaign scaling period was analyzed alongside data from the previous 6-month period (considered the baseline period).

---

## Executive Findings

### 1. Revenue Did Not Scale With Advertising Spend

Paid media spend increased by **350%**, and Net Sales increased by **23%**:

* Baseline Period: **$921,337 Net Sales**
* Marketing Campaign Scaling Period: **$1,137,173 Net Sales**
* Paid media spend: **$199,237 → $703,530**
* Blended MER: **4.62 → 1.62**
* Blended ROAS **4.37 → 1.69**

This indicates substantial deterioration in incremental media efficiency during marketing scale-up.

### 2. Attribution Became Increasingly Distorted

The **Attribution Match Rate** increased from **94% during the baseline period to 101% during the marketing scaling period**.

The metric compares platform-reported revenue with actual store-level Net Sales. A value above 100% indicates that aggregate platform-reported revenue exceeds recorded store revenue, providing a diagnostic signal for attribution overlap and potential organic-demand interception.

### 3. Channel Performance Diverged

Although web sessions and ATC doubled, the ATC rate did not significantly increase, and for TikTok Ads, it slightly decreased. The overall ROAS decreased by 61% from **4.37 to 1.69**.

### 4. Discounting Created Additional Margin Pressure

The baseline period operated without discounts.

During the campaign scaling period:

* **$36K** in checkout discounts were introduced.
* Discount rate reached **3.07%**.

The additional discounting helped support sales volume while reducing pricing and contribution-margin integrity.

---

## Data Architecture

The reporting model uses an enterprise **Fact Constellation Schema (Galaxy Schema) based on Kimball dimensional modeling principles**.

![Power BI Data Model](assets/data_model.png)

The model uses conforming dimensions and single-direction **1:N relationships** between dimensions and fact tables.

---

## Data Engineering & Quality Governance

### Customer Privacy

Customer identifiers were transformed into deterministic surrogate keys and a separate **SHA-256 hashing** customer key map.

This provides a consistent customer key while avoiding direct exposure of email addresses.

### Cold-Start / Left-Censoring Controls

Because the dataset covers a limited historical horizon, the model uses explicit `first_observed_order_date` flags to distinguish observed customer history from true lifetime history.

This prevents overstating customer lifetime value when the customer's history predates the available dataset.

### Order-Level Integrity

Transactional line-item data was grouped using distinct `order_id` logic before calculating order-level metrics.

This prevents multiple line items from being incorrectly counted as separate orders.

---

## 📐 Core DAX Measures

### Marketing Efficiency Ratio
Marketing Efficiency Ratio (MER) = divide([Net Sales],[Total Ad Spend],0)

MER provides a store-level view of revenue generated relative to total advertising investment.

### Attribution Match Rate
Attribution Match Rate = DIVIDE([Total Platform Reported Revenue], [Gross Sales], 0)

A value above **100%** indicates that aggregate platform-reported revenue exceeds actual store-level Net Sales and serves as a diagnostic for attribution overlap.

### Channel ROAS
Channel ROAS = divide([Channel Reported Revenue],[Total Ad Spend],0)

Evaluates return on ad spend at the isolated ad channel network for tactical campaign optimization.

---

## Power BI Dashboard

### Page 1 — Executive Overview & Commercial Health

![Executive Overview](assets/page1_executive_overview.png)

**Key insights:**

* Paid media investment increased by 350% from **$200K to $700K**
* Net Sales increased  by 23% from **$0.92M to $1.14M**
* Blended MER declined from **4.62 to 1.62**

---

### Page 2 — Paid Media Efficiency & Attribution Audit

![Channel Attribution](assets/page2_channel_attribution.png)

**Key insights:**

* Attribution Match Rate increased from **94% to 101%**
* Google Ads saw a slight increase in ATC rate from 6.37% to 6.46%, but a significant decline in ROAS from 4.84x to 2.19x.
* Meta ATC rate remained relatively unchanged from 6.47% to 6.49%, and an ROAS decline from 4.27x to 1.68x. 
* TikTok ATC rate declined from 6.61% to 6.44%, with an ROAS decline from 3.13x to 1.16x.
* All Channels saw traffic and ATC quantity doubled, but compared to impressions and amount spent, it was not enough to create an increase in marketing efficiency.

---

### Page 3 — Customer Cohorts & Product Economics

![Customer & Product Economics](assets/page3_customer_product_economics.png)

**Key insights:**

* H1 operated with **$0 discounts**.
* H2 introduced **$36K in checkout markdowns**.
* Discount penetration reached **3.07%**.
* H2 acquisition relied more heavily on returning customers and promotional buyers rather than expanding the net-new customer base.
* There is a bias in the data since active customers and first obvserved purchase data was based on the data available from the baseline and campaign scaling periods, without a separate list of active customers. Therefore, the majority (99%) of new customer acquisitions occurred during the baseline period, and only 0.1% happened during the baseline period. Nevertheless, this shows that even during the campaign scaling period, the majority of customers were returning customers, with 99% of purchases made by returning customers during this period.

---

## 💡 Strategic Recommendations

### 1. Reallocate Paid Media

**TikTok Prospecting**

Reduce TikTok prospecting investment by **50%** while rebuilding audiences and creative around purchase intent rather than inexpensive clicks.

**Google Search**

Implement negative brand-keyword exclusions to reduce paid interception of existing organic brand demand.

### 2. Protect Pricing & Margin

Replace broad sitewide discounts with **minimum-spend thresholds**.

Example:

```text
Free shipping on orders over $120
```

This approach is intended to protect AOV and reduce blanket discounting.

### 3. Change Marketing Governance

Move executive reporting away from platform-reported ROAS as the primary KPI.

Recommended core metrics:

* **Blended MER**
* **Customer Acquisition Cost (CAC)**
* **First-Order Contribution Margin**
* **Net Sales**
* **Discount Rate**
* **Attribution Match Rate**

The objective is to evaluate marketing performance against actual store economics rather than relying exclusively on platform attribution.

---

## 🎤 Executive Readout

The analysis can also be presented as a 6-slide executive deck:

| Slide | Topic                | Core Message                                                      |
| ----- | -------------------- | ----------------------------------------------------------------- |
| 1     | Executive Summary    | Paid media spend doubled without corresponding revenue growth     |
| 2     | Financial Trajectory | Spend growth diverged from top-line performance                   |
| 3     | Attribution          | Platform attribution exceeded store-level revenue                 |
| 4     | Channel Economics    | Traffic quality deteriorated, particularly in prospecting         |
| 5     | Margin               | Discounting introduced additional margin pressure                 |
| 6     | Action Plan          | Reallocate budget and implement store-level efficiency governance |

---

## 🛠️ Tools & Technologies

* **Power BI Desktop**
* **DAX**
* **Power Query / M**
* **GA4**
* **Kimball Star Schema**
* **Dimensional Modeling**
* **Marketing Attribution Analysis**
* **Customer Cohort Analysis**
* **E-Commerce Analytics**

---

## 📌 Key Takeaway

The central finding of this audit is that **increasing paid media investment did not produce proportional incremental revenue**.

The H2 scale-up coincided with:

```text
Ad Spend       +100%
Net Sales       ~0%
Blended MER     -50%
Discounts       +$26K
```

The analysis therefore shifts the focus from **"How much revenue did each platform claim?"** toward **"How much incremental, profitable revenue did the business actually generate?"**

That distinction is the foundation of the audit's recommended **Blended MER + Contribution Margin governance framework**.

---

## 📄 Project Deliverables

* Power BI `.pbix` dashboard
* Star-schema data model
* DAX metric library
* Processed analytical datasets
* Executive dashboard screenshots
* Executive presentation blueprint

---

## 👤 About This Project

This project demonstrates an end-to-end approach to **e-commerce performance analytics**, combining data modeling, data quality engineering, marketing attribution diagnostics, customer analysis, and executive-level business intelligence.
