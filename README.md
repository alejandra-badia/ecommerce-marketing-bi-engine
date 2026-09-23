**Power BI | DAX | Power Query | Marketing Attribution | E-Commerce Analytics**

A Power BI analytics project examining marketing efficiency, channel attribution, customer purchasing behavior, and customer lifetime value (LTV) for a fictional direct-to-consumer (D2C) e-commerce brand.

The project investigates a critical business question:
> **Did a significant increase in marketing investment translate into sustainable revenue growth, efficient customer acquisition, and long-term customer value?**

---

## Project Overview
**Apex Gear Co.** is a fictional D2C brand selling outdoor and performance gear across North America, Europe, and APAC.

During the first half of 2026, the company substantially increased its marketing investment. This project compares the scaling period against the preceding six-month baseline to evaluate how revenue, marketing efficiency, channel performance, and observed customer purchasing behavior changed.

The analysis combines sales, marketing performance, and web traffic data in Power BI to provide a consolidated view of business performance.

### Objectives
* Evaluate whether revenue growth kept pace with increased marketing spend.
* Compare blended marketing efficiency and channel-level ROAS across periods.
* Examine whether higher traffic and Add-to-Cart (ATC) activity translated into stronger commercial outcomes.
* Assess observed customer purchasing patterns and cohort composition.
* Identify where additional campaign-level analysis is needed before making budget allocation decisions.
* Develop evidence-based recommendations for improving acquisition efficiency and sustainable growth.

---

## Analysis Period

The analysis compares two six-month periods:

| Period | Date Range | Description |
| -------- | -------------------------- | ----------------------------------------- |
| Baseline | July 1 – December 31, 2025 | Reference period before the scaling phase |
| Scaling | January 1 – June 30, 2026 | Period of increased marketing investment |

---

## Executive Summary

Marketing investment increased substantially during the scaling period, but revenue growth did not keep pace.

| KPI / Metric | Baseline | Scaling | Change |
| :--- | ---: | ---: | ---: |
| Total Ad Spend | $199,237 | $703,530 | +253% |
| Net Sales | $921,337 | $1,137,173 | +23% |
| Total COGS | $305,685 | $389,457 | +27% |
| Gross Profit | $615,652 | $747,716 | +21% |
| Marketing Profit | $416,415 | $44,186 | -89% |
| Marketing Profit Margin % | 45.20% | 3.89% | -41.31 percentabe points (-91%) |
| MER | 4.62x | 1.62x | -65% |
| ROAS | 4.37x | 1.69x | -61% |
| Attribution Match Rate | 94% | 101% | +7 percentage points |
| Checkout Discounts | — | $36,000 | — |
| Checkout Discount Rate | — | 3.07% | — |

*Note: The scaling-period spend was approximately 3.5 times the baseline spend, equivalent to an increase of approximately 253%.*

### Key Takeaways

**1. Revenue increased, but substantially more marketing investment was required.**
Net Sales grew 23%, while ad spend increased approximately 253%. This divergence coincided with a sharp decline in blended marketing efficiency.

**2. Blended marketing efficiency deteriorated during the scaling period.**
MER declined from 4.62x to 1.62x, while blended ROAS declined from 4.37x to 1.69x. These results indicate that the additional marketing investment was associated with lower reported revenue efficiency.

**3. Channel-level ROAS declined across all three platforms.**
Google Ads, Meta, and TikTok all recorded lower ROAS during the scaling period.

**4. Profit remaining after COGS and advertising declined sharply.**
Gross Profit After Ad Spend fell from approximately $416K to $44K (−89%), while its share of Net Sales declined from 45.20% to 3.89%. Although this measure remained positive during the scaling period, substantially less profit remained after order-related costs and advertising.

**5. Traffic and Add-to-Cart volume increased, but this did not translate into proportional efficiency gains.**
The increase in traffic and ATC activity suggests that the business generated more engagement. However, this additional engagement growth did not generate a significant increase of ATC, so the ATC rate remained relatively unchanged, and for the TikTok channel, the ATC rate showed a slight decline. 

**6. Majority of customers during the marketing campaign scaling period were returning customers.**
Basis for calculating new and returning customers:
* A new customer was defined as a customer with an observed first order date during the period being analyzed
* A returning customer was defined as a customer who already had an observed first order date prior to the period being analyzed

Approximately 99% of customers in the scaling period were attributed to returning customers under the available first-observed-order classification. Only 12 customers were classified as new during this period. Note that since pre-baseline customer history was unavailable customers may be misclassified as new customers, when they could actually be returning customers. Nevertheless, this does not invalidate that at least 99% of customers during the marketing scaling period were returning customers.

---

## BI Requirements Engineering & Measurement Planning

Before building ETL pipelines or writing DAX, a formal **BI Measurement Plan** was developed to bridge commercial business requirements with technical schema design, using the [BI Measurement Planner](https://github.com/alejandra-badia/bi-measurement-planner) framework. By applying this structured planning framework upfront, business questions were systematically translated into user stories, technical entity-grain requirements, and deterministic mathematical definitions prior to implementation. This prevented metric ambiguity, eliminated redundant transformations, and ensured direct lineage from executive questions to transactional data fields.

### 1. Stakeholder User Stories
Business needs were scoped into role-based analytical user stories within the planner:
* **Chief Marketing Officer (CMO):** *"I need to compare top-line store sales against platform-reported ad revenue across baseline and scaling periods, so I can diagnose attribution overlap and prevent double-counting across networks."*
* **Head of Performance Marketing:** *"I need granular channel metrics (CPC, CTR, Add-to-Cart Intent, and Channel ROAS) across Google, Meta, and TikTok, so I can identify which acquisition channels are experiencing media fatigue."*
* **Director of E-Commerce / Finance:** *"I need to track realized Net Sales, checkout discount penetration, and returning customer purchase share, so I can ensure promotional campaigns aren't eroding unit contribution margin."*

### 2. Business Metric Lifecycle & Process Flow
To avoid metric drift and governance discrepancies, each KPI followed the lifecycle defined in the **BI Measurement Planner**:
1. **Business Problem & Hypothesis Formulation:** Define commercial intent (e.g., verifying whether media scaling cannibalized baseline organic demand).
2. **Grain & Entity Mapping:** Isolate source tables, primary/foreign keys, and data granularity across Shopify, GA4, and Ad networks.
3. **DAX Mathematical Specification:** Document formal formulas, boundary cases, and divide-by-zero safeguards (`DIVIDE(..., 0)`).
4. **Data Verification & Audit:** Reconcile aggregated Power BI measures against raw transactional exports.

### 3. Requirements & Traceability Matrix (Excerpt)

| Strategic Theme | Core Metric / KPI | Reporting Grain | Source Table(s) | Key Fields Required | Target Decision / Action |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Media Efficiency** | MER | Store / Period / Monthly | `fact_sales_line_items`, `fact_marketing_performance` | `gross_amount`, `discount_amount`, `returns`, `spend` | Determine macro budget scaling viability |
| **Attribution Audit** | Attribution Match Rate | Store / Period | `fact_marketing_performance`, `fact_sales_line_items` | `platform_reported_revenue`, `gross_amount` | Identify aggregate self-reported attribution overlap |
| **Channel Quality** | ATC Rate (%) | Daily / Site-Level | `fact_web_traffic` | `sessions`, `add_to_carts` | Diagnose intent degradation and traffic drop-off |
| **Pricing Integrity** | Checkout Discount Rate | Order / Line-Item | `fact_sales_line_items` | `discount_amount`, `gross_amount` | Monitor margin dilution and coupon reliance |
| **Customer Retention**| Returning Customer % | Customer Cohort / Period | `dim_customers` | `customer_key`, `observed_lifetime_orders` | Quantify reliance on returning base vs. new acquisitions |

> 🔗 *Explore the full governance methodology, template blueprints, and measurement workflows in the [BI Measurement Planner Repository](https://github.com/alejandra-badia/bi-measurement-planner).*

---

## Dashboard Preview

The Power BI report is organized into three analytical views.

### Page 1 — Executive Overview

A consolidated view of business performance across the baseline and scaling periods, highlighting sales growth, marketing investment, blended efficiency, and key business KPIs.

![Executive Overview](assets/page1_executive_overview.png)

### Page 2 — Channel Attribution

A channel-level comparison of marketing performance, including reported revenue, ROAS, and Add-to-Cart rates across Google Ads, Meta, and TikTok.

![Channel Attribution](assets/page2_channel_attribution.png)

### Page 3 — Customer & Product Economics

An exploration of observed customer purchasing behavior, cohort composition, and product-level economics to support further investigation into customer value and commercial performance.

![Customer & Product Economics](assets/page3_customer_product_economics.png)

---

## Marketing Performance Analysis

### Blended Marketing Efficiency

The scaling period generated higher Net Sales, but marketing efficiency declined substantially.

* Net Sales increased from $921K to $1.14M.
* Ad spend increased from approximately $199K to $704K.
* Blended MER declined from 4.62x to 1.62x.
* Blended ROAS declined from 4.37x to 1.69x.

The central business concern is not an absence of revenue growth. Rather, **revenue growth lagged far behind the expansion in marketing investment.**

This raises an important question for the next stage of analysis: which campaigns generated incremental revenue and new customers, and which may have captured demand that would have occurred without the additional spend?

### Profitability Impact of Marketing Scale-Up
To assess performance beyond revenue efficiency, the analysis also evaluates Gross Profit After Ad Spend: Net Sales less COGS and advertising spend.

| KPI                              | Baseline | Scaling |                   Change |
| -------------------------------- | -------: | ------: | -----------------------: |
| Marketing Profit       | $416,415 | $44,186 |                   −89% |
| Marketing Profit Margin %  |   45.20% |   3.89% | −41.31 percentage points (-91%) |

Gross Profit After Ad Spend declined by approximately $372K despite Net Sales increasing by 23%. The share of Net Sales remaining after COGS and advertising also fell substantially, from 45.20% to 3.89%.

This indicates that considerably less profit remained after order-related costs and advertising during the scaling period. While the measure remained positive at approximately $44K, the Marketing Profit deteriorated by 89%.

### Baseline Seasonality & Stability Audit

When comparing a second-half baseline (July–December 2025) against a first-half scaling period (January–June 2026), a primary analytical concern is whether typical Q4 retail seasonality (Black Friday, Cyber Monday, holiday gifting) artificially inflated baseline performance.

An audit of the daily and monthly transaction pacing revealed an important pattern:

* **Absence of a Holiday Surge:** The November–December 2025 data did not show an abnormal holiday demand spike. Sales and conversion volumes remained relatively flat and consistent with the earlier months of H2 2025.
* **Q1 Pacing Context:** Similarly, January and February 2026 did not appear to have an exaggerated post-holiday hangover drop.

**Analytical Implication:** Although holiday seasonality can affect the data, significant seasonality peaks and troughs were not observed.

### Channel-Level Performance

| Channel | Baseline ATC Rate | Scaling ATC Rate | Baseline ROAS | Scaling ROAS |
| ---------- | ----------------: | ---------------: | ------------: | -----------: |
| Google Ads | 6.37% | 6.46% | 4.84x | 2.19x |
| Meta | 6.47% | 6.49% | 4.27x | 1.68x |
| TikTok | 6.61% | 6.44% | 3.13x | 1.16x |

### Channel Observations

**Google Ads**
Google Ads maintained a relatively stable ATC rate, increasing from 6.37% to 6.46%. However, ROAS declined from 4.84x to 2.19x, indicating that the increase in engagement did not correspond to equivalent reported revenue efficiency.

**Meta**
Meta's ATC rate remained nearly unchanged, moving from 6.47% to 6.49%, while ROAS declined from 4.27x to 1.68%. This warrants further analysis of the campaigns responsible for spend expansion and their contribution to incremental customer acquisition.

**TikTok**
TikTok's ATC rate decreased from 6.61% to 6.44%, while ROAS declined from 3.13x to 1.16x. Further investigation is needed to determine whether the change reflects audience expansion, campaign mix, attribution effects, or other factors.

These channel-level results identify areas for deeper investigation, but they do not establish which individual campaigns should be scaled or reduced. Campaign-level acquisition, margin, and incrementality data would be needed to support those decisions.

### Attribution Match Rate

**Attribution Match Rate = Total Platform Reported Revenue ÷ Gross Sales**

This metric compares aggregate revenue reported by advertising platforms against store-level Gross Sales.

A value above **100%** indicates that aggregate platform-reported revenue exceeds the Gross Sales recorded in the store data. This serves as a diagnostic signal for potential attribution overlap, differences in platform reporting methodology, or other measurement discrepancies.

---

## Customer Cohort & LTV Analysis

The customer analysis examines observed purchasing behavior and the distribution of customers across available cohorts.

### Key Observation

During the scaling period, only 12 customers were classified as new under the available first-observed-order methodology. Approximately 99% of scaling-period customers were returning customers.

This is a notable data finding, but it should not be interpreted as definitive evidence of customer loyalty, strong retention, or a lack of acquisition activity.

### Important Data Limitation: Left-Censored Customer History

The dataset does not include a complete historical customer record or a separate, comprehensive list of customers active before the baseline period.

As a result:

* A customer's first observed order is not necessarily their true first-ever purchase.
* Customers who purchased before the available data window may be classified as new when they are actually existing customers.
* The observed new-customer count may not represent true acquisition volume.
* The returning-customer share cannot independently establish retention, loyalty, or customer lifetime value.

**The 99% returning-customers share should therefore be treated as an observed dataset pattern—not a validated retention rate or proof that acquisition campaigns are ineffective.**

A more reliable LTV and retention analysis would require complete customer purchase history, a validated acquisition date, and consistent customer-level transaction records.

Nevertheless, a holistic view of the available data shows that returning customers make a significant portion of the customer base.

---

## Strategic Recommendations

During the scaling period, marketing spend increased by 253%, while Net Sales grew by only 23%. Blended MER declined from 4.62x to 1.62x, and blended ROAS fell from 4.37x to 1.69x.

These results indicate that the business is generating revenue less efficiently at its current level of marketing investment.

### 1. Reassess Marketing Spend and Channel Allocation

Marketing investment increased approximately 3.5× during the scaling period, while net sales increased approximately 1.23×. This indicates a substantial decline in observed net sales efficiency relative to marketing spend. The decline in blended efficiency suggests that the current investment level is not delivering revenue growth proportionate to the increase in spend.

Based on this trend, the recommendation is to reassess further budget increases rather than continuing to scale at the same pace by default. Before committing additional spend, management should review channel-level performance and validate whether incremental investment is generating sufficient contribution margin. A controlled budget test could help determine whether additional spend delivers acceptable incremental returns.

This analysis identifies a deterioration in observed sales efficiency; it does not independently establish the causal or profit-maximizing effect of marketing spend.

| KPI | Baseline | Scaling | Change |
| -------------- | -------: | ---------: | -----: |
| Total Ad Spend | $199,237 | $703,530 | +253% |
| Net Sales | $921,337 | $1,137,173 | +23% |
| Blended MER | 4.62x | 1.62x | -65% |
| Blended ROAS | 4.37x | 1.69x | -61% |


| Channel | Baseline ROAS | Scaling ROAS | Change |
| ---------- | ------------: | -----------: | -----: |
| Google Ads | 4.84x | 2.19x | -55% |
| Meta | 4.27x | 1.68x | -61% |
| TikTok | 3.13x | 1.16x | -63% |

**Recommended actions:**
* Reassess continuing paid marketing spend scaling
* Review spend across Meta, Google, and TikTok and reassess channel budget allocation
* Monitor Net Sales, MER, ROAS, and customer acquisition during controlled budget test

### 2. Audit Campaign-Level Acquisition & Incrementality

Reducing inefficient spend is the immediate priority. The next step is to determine how the remaining budget should be allocated.

The current campaign structure includes:

| Platform | Campaigns |
| ---------- | ------------------------------------------------------- |
| Meta | Brand Awareness, Prospecting Broad, Retargeting |
| Google Ads | Search Brand Core, Non-Brand Outerwear, Performance Max |
| TikTok | Spark Influence UGC, TopView, Brand Push |

These campaigns serve different roles across awareness, prospecting, retargeting, and demand capture. Platform-level ROAS alone may obscure meaningful differences in their contribution.

**Recommended analysis:**

* Compare campaign- and ad-level spend, reported revenue, and ROAS across the baseline and scaling periods.
* Identify which campaigns and ads account for the largest spend increases and ROAS declines.
* Examine new-customer conversions and acquisition cost at the most granular level supported by the data.
* Compare prospecting and awareness activity with retargeting and brand-demand capture.
* Investigate potential attribution overlap across campaigns and platforms.
* Where feasible, use holdouts, lift tests, or geo experiments to estimate incremental impact.

**Decision principle:** Use campaign-level evidence to refine budget allocation, but do not let the absence of perfect incrementality data prevent action on the substantial efficiency decline already observed.

### 3. Validate Customer History & Build a More Reliable LTV View

Approximately 99% of scaling-period customers were returning customers, while only 12 customers were classified as new under the available first-observed-order methodology.

This is a notable signal to investigate alongside the decline in marketing efficiency. However, it does not independently prove that acquisition campaigns are ineffective or that existing customers are being neglected. Incomplete historical customer records may affect the new-versus-returning classification, and existing customers may be repurchasing through natural demand.

**Recommended next steps:**

* Validate first-purchase dates against the fullest available transaction history.
* Recalculate new-versus-returning customer counts using a consistent customer-level definition.
* Establish cohort-based repeat purchase rates over defined time windows.
* Analyze time between purchases, order frequency, and customer-level revenue.
* Calculate contribution-margin-based LTV when sufficient cost and customer history data are available.

The goal is to distinguish genuine repeat purchasing from classification effects and improve visibility into the role of acquisition and retention in business growth.

### 4. Test Lifecycle Marketing & Targeted Offers

Lifecycle marketing may offer a complementary growth opportunity, but the current analysis does not establish that existing customers are under-monetized or that additional discounts would generate incremental revenue.

Potential tests include:

* Post-purchase email journeys
* Product cross-sell and replenishment messaging, where relevant
* Win-back campaigns for customers with validated inactivity
* Targeted offers for specific customer segments
* Holdout groups to measure incremental repeat purchases and contribution margin

These initiatives should be evaluated based on incremental purchases and contribution—not simply attributed revenue.

### 5. Protect Contribution Margin as Marketing Scales

The scaling period included approximately $36K in checkout discounts, representing a 3.07% discount rate, calculated as Total Discount Amount divided by Gross Sales.

Discounting may support conversion, but its business impact depends on whether it generates incremental sales and whether the resulting margin remains sustainable.

**Recommended next steps:**

* Track discount usage and discounted sales by channel and campaign
* Compare contribution margin before and after discounts
* Test targeted discounts against non-discounted control groups where feasible
* Evaluate campaign performance using contribution after marketing and discount costs, when the required cost data is available

The goal is to evaluate growth quality—not revenue alone.

### Summary

Further campaign-level acquisition, incrementality, and customer LTV analysis should then guide how the remaining budget is allocated and where future investment can generate sustainable, incremental growth.

The immediate recommendation is to hold back from further aggressive marketing scaling and reassess the current level of paid media investment. During the scaling period, ad spend increased 253% while Net Sales grew 23%, and Marketing Profit (Gross Profit After Ad Spend) declined by approximately 89%, from $416K to $44K.

These results indicate a substantial deterioration in observed revenue efficiency and profit remaining after COGS and advertising. Management should review the current investment level before committing to further expansion.

The next step is to use campaign-level performance, contribution-margin analysis, and incrementality testing where feasible to refine channel and campaign allocation. The current analysis supports reassessing the pace of scaling, but does not identify a precise profit-maximizing budget or establish which individual channels should be reduced.

---

## Data Model & Architecture

The Power BI model uses a **Kimball-style dimensional model implemented as a fact constellation (galaxy) schema**, with shared dimensions connecting multiple fact tables.

This structure supports analysis across sales, marketing performance, and web traffic while maintaining distinct fact-table grains.

![Power BI Data Model](assets/data_model.png)

### Fact Tables

| Table | Description |
| ---------------------------- | --------------------------------------------------------------------------------- |
| `fact_sales_line_items` | Sales line-item data used for revenue and product-level analysis |
| `fact_marketing_performance` | Marketing performance data used for spend, reported revenue, and channel analysis |
| `fact_web_traffic` | Web traffic data used to analyze sessions and engagement metrics |

### Shared Dimensions

| Table | Description |
| --------------- | ------------------------------------------------------- |
| `dim_customers` | Customer attributes and customer-level analysis |
| `dim_calendar` | Date-based analysis across the model |
| `dim_channels` | Marketing channel attributes |
| `dim_products` | Product attributes product-level analysis |

The shared dimensions provide consistent analytical context across the fact tables. An additional `_Measures` table was used to organize DAX measures and is not a business fact table or dimension.

![Measures Table With Folder Organization](assets/measures_table.png)

---

### Web Traffic Modeling Decision

The `fact_web_traffic` table retains its daily channel/traffic-source grain. Although campaign- and ad-level attributes could potentially be extracted into additional dimensions, the traffic table was kept at its available reporting grain to maintain a focused model aligned with the scope of the analysis.

This means campaign- and ad-level drill-through is based on the marketing performance data available in the report; it should not be assumed that the web traffic fact independently supports the same level of campaign/ad attribution.

---

## Data Engineering & Modeling

Several data preparation and modeling practices were used to support analytical consistency.

### Customer Key Standardization

A SHA-256-based customer key mapping process was used to standardize customer identifiers across relevant data sources.

This supports consistent customer-level analysis while avoiding the use of raw customer identifiers in the analytical model.

### First-Observed-Order Logic

Customer first-observed order dates were derived from the available transaction history to support cohort classification.

Because the dataset does not include complete historical customer records, first-observed dates are not guaranteed to represent true customer acquisition dates. This limitation is carried through the interpretation of cohort findings.

### Order-Level Integrity

Distinct `order_id` logic was used where appropriate to avoid counting individual sales line items as separate orders.

This is particularly important when analyzing order counts, customer purchasing behavior, and sales metrics across a line-item-level fact table.

### Dimensional Modeling

The model separates sales, marketing, and web traffic into distinct fact tables, with shared dimensions supporting cross-functional analysis.

This structure helps preserve each fact table's grain and reduces the risk of combining measures at incompatible levels of detail.

---

## Core Metrics & Definitions

The Power BI report uses DAX measures to evaluate marketing efficiency, sales performance, customer behavior, and website engagement. The following metrics represent the key KPIs and supporting measures used throughout the analysis.

### Marketing & Business Performance

| Metric | Definition | Analytical Purpose |
| :--- | :--- | :--- |
| Net Sales | Gross Order Value − Total Discount Amount − Total Return Amount | Measures realized sales after discounts and returns |
| Total COGS | Sum of line-level costs (`quantity` × conformed product `unit_cost`) | Measures total landed product inventory cost sold |
| Gross Profit | Net Sales − Total COGS | Measures realized gross dollar profit generated before marketing and operating expenses |
| Gross Margin % | Gross Profit ÷ Net Sales | Evaluates fundamental product-level pricing power and markup efficiency |
| Total Ad Spend | Sum of advertising spend across analyzed platforms | Measures paid media investment |
| Blended MER | Net Sales ÷ Total Ad Spend | Evaluates store-level sales relative to advertising investment |
| Blended ROAS | Consolidated platform-reported revenue ÷ Total Ad Spend, using the report's measure logic | Evaluates blended reported advertising return |
| Channel ROAS | Channel Reported Revenue ÷ Total Ad Spend | Compares reported advertising return at the channel level |
| Attribution Match Rate | Total Platform Reported Revenue ÷ Gross Sales | Diagnoses differences between aggregate platform-reported revenue and store-level Gross Sales |
| Marketing Profit | Gross Profit − Total Ad Spend | Measures realized commercial cash contribution after inventory and acquisition media costs |
| Marketing Profit Margin % | Marketing Profit ÷ Net Sales | Evaluates retained operating contribution as a percentage of net revenue |
| Incremental Marketing Profit | Scaling-Period Marketing Profit − Baseline Marketing Profit | Compares commercial marketing profit between the two operational periods |
| Incremental Profit Growth % | Incremental Marketing Profit ÷ Baseline Marketing Profit | Measures the relative percentage change in commercial profit versus baseline |

### Customer Acquisition & Lifetime Value

| Metric | Definition | Analytical Purpose |
| :--- | :--- | :--- |
| Blended CAC | Total Ad Spend ÷ Total New Customers Acquired | Estimates paid media cost per observed new customer |
| Observed Average Customer LTV | Average of observed customer lifetime spend in the available data | Describes observed customer monetization |
| Total New Customers Acquired | Distinct count of customers classified as new using first-observed-order logic | Supports observed acquisition analysis |
| Total Returning Customers | Total Active Customer Base − Total New Customers Acquired | Estimates returning customers under the report's classification logic |
| New Customer Acquisition % | Total New Customers Acquired ÷ Total Active Customer Base | Measures the observed new-customer share |
| Returning Customer % | Total Returning Customers ÷ Total Active Customer Base | Measures the observed returning-customer share |

### Traffic, Engagement & Order Metrics

| Metric | Definition | Analytical Purpose |
| :--- | :--- | :--- |
| Click-Through Rate (CTR) | Total Ad Clicks ÷ Total Ad Impressions | Measures the proportion of ad impressions resulting in clicks |
| Cost Per Click (CPC) | Total Ad Spend ÷ Total Ad Clicks | Measures average advertising cost per click |
| Total Web Sessions | Sum of GA4 sessions | Measures website traffic volume |
| Unique Site Visitors | Distinct count of visitors, according to available GA4 data | Measures observed audience reach |
| Total Add-to-Carts | Sum of Add-to-Cart events | Measures shopping engagement |
| ATC Rate | Add-to-Cart rate, as defined in the report | Evaluates the rate of Add-to-Cart activity |
| Average Order Value (AOV) | Average order value, using the report's order-level logic | Measures average transaction value |
| Total Orders Count | Distinct count of `order_id` | Measures order volume without counting each line item as a separate order |
| Total Units Sold | Sum of units sold | Measures product sales volume |
| Total Discount Amount | Sum of discounts recorded in Shopify sales data | Measures discount value |
| Checkout Discount Rate | Total Discount Amount ÷ Gross Sales | Measures discounts relative to Gross Sales |

### Metric Interpretation & Limitations

* **MER and ROAS are not interchangeable.** MER uses store-level Net Sales, while ROAS uses platform-reported revenue. Differences in attribution and reporting methodology can cause these metrics to diverge.
* **Attribution Match Rate above 100% is a diagnostic signal.** It indicates that aggregate platform-reported revenue exceeds store-level Gross Sales. It does not, by itself, establish attribution accuracy, identify the source of overlap, or measure incremental revenue.
* **COGS uses annual standard costing.** Product costs are held fixed at standard `unit_cost` across both baseline and scaling cohorts, isolating media efficiency and promotional discounting from supplier cost inflation. Includes direct product costs, fulfillment and pick-and-pack costs, payment processing fees, variable shipping subsidies, and other variable costs directly associated with fulfilling customer orders. COGS is calculated based on units sold and the associated unit cost.
* **Incremental Marketing Profit is a period-over-period comparison.** It does not establish that marketing scaling alone caused the change.
* **CAC and observed LTV depend on customer classification and history.** Incomplete pre-baseline customer records limit the reliability of true acquisition cost, retention, and lifetime value conclusions.
* **Discount Rate uses Gross Sales as its denominator.** The report calculates Checkout Discount Rate as Total Discount Amount ÷ Gross Sales.

---

## Technical Implementation

### Sample DAX MEASURES

```dax
Marketing Efficiency Ratio (MER) = divide([Net Sales],[Total Ad Spend],0)
MER provides a store-level view of revenue generated relative to total advertising investment.
Attribution Match Rate = DIVIDE([Total Platform Reported Revenue], [Gross Sales], 0)
A value above 100% indicates that aggregate platform-reported revenue exceeds actual store-level Net Sales and serves as a diagnostic for attribution overlap.
Channel ROAS = divide([Channel Reported Revenue],[Total Ad Spend],0)
This measure tracks the proportion of gross sales surrendered through discounting.
Net Sales = [Gross Sales]-[Total Discount Amount]-[Total Return Amount]
Net Sales provides the revenue after subtracting customer returns, price allowances, and sales discounts from its total gross sales.
Gross Profit = [Net Sales] - [Total COGS]
Gross Profit provides the generated profit after subtracting the Cost of Goods Sold from Net Sales
Marketing Profit = [Gross Profit] - [Total Ad Spend]
Marketing Profit Margin % = DIVIDE([Marketing Contribution], [Net Sales], 0)
```
### Data Transformation
|![Table Transformation Folder Organization](assets/tables_folder_oraganization.png) 

|![Channel Marketing Performance Tables](assets/merged_marketing_performance_data.png) | ![Merged Marketing Performance Data](assets/merged_marketing_performance_data.png)|

| ![Original Customer Dimensions Table](assets/dim_customers.png) | ![Transformed Dimesions Table](assets/dim_customers_tranformed.png) |

### Validation Examples

---

## Tools & Technologies
* **Power BI** — Interactive dashboards, data modeling, DAX measures, drill-through navigation, and cross-page analysis
* **DAX** — KPI calculations, time-period comparisons, and business metric logic
* **Dimensional Modeling** — Fact constellation / galaxy schema with shared dimensions
* **Data Engineering & Transformation** — Customer key standardization, first-observed-order logic, and order-level integrity checks
* **Data Visualization & Report Design** — Executive KPI reporting, channel performance analysis, and campaign/ad-level drill-through from the channel report

---

## Limitations & Considerations

The findings should be interpreted within the limits of the available data and reporting methodology.

1. **Incomplete customer history:** First-observed customer dates may not reflect true acquisition dates, limiting the reliability of new-versus-returning classification and LTV conclusions.
2. **Platform attribution:** Platform-reported revenue may overlap across channels and should not be interpreted as incremental revenue without further validation.
3. **Descriptive period comparison:** Differences between the baseline and scaling periods do not establish that marketing spend alone caused the observed changes.
4. **Campaign-level detail:** Channel-level results do not identify the specific campaigns, audiences, or placements responsible for the decline in reported efficiency.
5. **Profitability:** Revenue efficiency is not equivalent to profitability. A complete assessment would require relevant product costs, fulfillment costs, and other contribution-margin inputs.
6. **Customer lifecycle measurement:** The current cohort analysis does not independently establish validated retention rates, customer loyalty, or true customer lifetime value.

These limitations inform the recommended next steps and help distinguish observed results from hypotheses requiring further testing.

---

## Project Deliverables

This repository provides an analytics package encompassing strategic planning, dimensional engineering, metric definitions, and executive presentation layers:

| Deliverable Artifact | Format / Location | Description |
| :--- | :--- | :--- |
| **Interactive Executive Dashboard** | [`/model/ecommerce_marketing_analytics.pbix`](model/) | 3-page interactive Power BI report covering Executive Commercial Health, Channel Attribution & Ad Efficiency, and Customer Cohorts & Product Economics. |
| **JSON Measurement Spec** | [`/docs/bi_measurement_plan.md`](docs/bi_measurement_plan.md) | Structured requirements blueprint linking business user stories, metric lifecycles, and data-grain mappings built using the [BI Measurement Planner](https://github.com/alejandra-badia/bi-measurement-planner). |
| **Kimball Dimensional Model Architecture** | [`/assets/data_model.png`](assets/data_model.png) | Fact Constellation (Galaxy Schema) specification connecting 3 fact tables across 4 conformed dimensions via clean 1:N single-direction relationships. |
| **Data Dictionary** | [`/dax/measures_library.dax`](dax/measures_library.dax) | Centralized, documented DAX script containing all business calculations (MER, ROAS, Marginal MER, Attribution Match Rate, and Cohort logic) with divide-by-zero safeguards. |
| **Executive Presentation Deck** | [`/docs/executive_briefing.pdf`](docs/executive_briefing.pdf) | Slide deck briefing summarizing performance decay diagnostics, organic cannibalization risks, and capital reallocation recommendations. |

---

## Conclusion

Apex Gear Co.'s scaling period generated 23% Net Sales growth alongside a substantial increase in marketing investment. However, blended MER and ROAS declined considerably, and reported ROAS fell across Google Ads, Meta, and TikTok.

The recommendation is to reduce overall paid media spend and reassess channel investment—rather than continuing to scale at the same pace. The next phase of analysis should focus on understanding the quality and incrementality of growth—not simply increasing or decreasing spend based on blended performance.

A campaign-level acquisition and incrementality audit, supported by stronger customer-history validation and contribution-margin measurement, would provide a more reliable basis for future budget allocation.

**The key takeaway:** Sustainable growth requires understanding not only how much revenue marketing reports, but how much additional customer value it creates—and at what economic cost.


Apex Gear Co.'s scaling period generated 23% Net Sales growth alongside a 253% increase in marketing investment. Blended MER and ROAS declined considerably, and reported ROAS fell across Google Ads, Meta, and TikTok.

Gross Profit After Ad Spend declined approximately 89.4%, from $416K to $44K, while its share of Net Sales fell from 45.20% to 3.89%. Although the measure remained positive during the scaling period, substantially less profit remained after COGS and advertising.

The recommendation is to hold back from further aggressive scaling and reassess the current level of marketing investment. Campaign-level contribution analysis and incrementality testing can then help guide future budget allocation. The period comparison is descriptive and does not isolate the causal impact of marketing spend.

**The key takeaway:** Sustainable growth requires evaluating not only revenue and platform-reported returns, but also marketing efficiency, return on ad spend, and marketing profit (the profit remaining after order-related costs and advertising)—and whether additional investment generates sufficient incremental value.
