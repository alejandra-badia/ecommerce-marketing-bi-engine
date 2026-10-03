# Data Dictionary & Specification: E-Commerce Marketing & LTV Analytics

> **Version:** `1.0.0` | **Status:** `DRAFT` | **Security Level:** `CONFIDENTIAL`

**Prepared By:** Alejandra Badia | **Technical Owner:** Lead BI Architect

---

## 1. Executive Summary & Scope
**Overview:**
Apex Gear Co. is a Direct-to-Consumer (D2C) outdoor & performance e-commerce gear company operating across North America, Europe, and APAC with ~$15M in annual revenue. Over the past 2 quarters, executive leadership allocated a significant budget to scale marketing campaigns across Meta (Facebook/Instagram), Google Ads, and TikTok. While top-line site traffic increased, Gross Revenue remained flat, and overall Customer Acquisition Cost (CAC) surged by 28% YoY.

**Objective:**
Unify siloed data across ad platforms, web analytics, CRM, and e-commerce orders to evaluate true marketing performance against historical baselines. Specifically, analyze whether the expanded marketing investment increased or eroded overall Marketing ROI, identify performance shortfalls across channels, and establish a data-driven path forward to restore or surpass pre-scaling ROI efficiency through strategic budget reallocation.

### 1.1 Process-Driven Workflow Map
| Step / Phase | Summary | Key Variables | Derived Metrics | System / Owner |
| :--- | :--- | :--- | :--- | :--- |
| **1. Ad Exposure & Impression** | User views paid ad creative on social feed or search engine. | `ad_id, campaign_id, placement` | Ad Impressions, Total Ad Spend | Meta / Google / TikTok Ads |
| **2. Ad Click & Redirection** | User clicks ad link and is redirected to Apex Gear online store. | `utm_source, utm_campaign, gclid` | Ad Clicks, Outbound CTR | Ad Platforms / Traffic Engine |
| **3. Web Session & Product Browsing** | User navigates catalog, views product detail pages, and adds items to cart. | `session_id, user_pseudo_id, device` | Total Web Sessions, Add-to-Carts | Google Analytics 4 (GA4) |
| **4. Order Checkout & Payment** | User completes checkout payment and order is recorded. | `order_id, customer_id, promo_code` | Gross Order Value, Total Orders Count | Shopify E-Commerce |
| **5. Order Fulfillment & Returns** | Order is processed, shipped, or returned by customer. | `tracking_number, return_reason` | Net Revenue, Total Return Amount | Shopify / ERP |
| **6. Retention & Cohort LTV** | Customer engages in repeat purchases over a 12-month window. | `customer_id, first_order_date` | 12-Month LTV, Repeat Order Rate | Shopify / CRM |

## 2. Base Metrics Catalog
| Metric Name | Aggregation | Data Type | Target Table | Table Type | Table Grain | Primary Source |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Total Ad Spend** | `SUM` | Currency | `fact_marketing_performance` | transaction_fact | One row per day, per unique ad creative | Google Ads, Meta Ads, TikTok Ads |
| **Ad Impressions** | `SUM` | Whole_number | `fact_marketing_performance` | transaction_fact | One row per day, per unique ad creative | Google Ads, Meta Ads, TikTok Ads |
| **Ad Clicks** | `SUM` | Whole_number | `fact_marketing_performance` | transaction_fact | One row per day, per unique ad creative | Google Ads, Meta Ads, TikTok Ads |
| **Total Web Sessions** | `SUM` | Whole_number | `fact_web_traffic` | transaction_fact | One row per day, per channel/traffic source | Google Analytics 4 (GA4) |
| **Unique Site Visitors** | `DISTINCTCOUNT` | Whole_number | `fact_web_traffic` | transaction_fact | One row per day, per channel/traffic source | Google Analytics 4 (GA4) |
| **Total Add-to-Carts** | `SUM` | Whole_number | `fact_web_traffic` | transaction_fact | One row per day, per channel/traffic source | Google Analytics 4 (GA4) |
| **Gross Order Value** | `SUM` | Currency | `fact_sales_line_items` | transaction_fact | One row per order line item | Shopify |
| **Total Discount Amount** | `SUM` | Currency | `fact_sales_line_items` | transaction_fact | One row per order line item | Shopify |
| **Total Return Amount** | `SUM` | Currency | `fact_sales_line_items` | transaction_fact | One row per order line item | Shopify |
| **Total Orders Count** | `DISTINCTCOUNT` | Whole_number | `fact_sales_line_items` | transaction_fact | One row per order line item | Shopify |
| **Total New Customers Acquired** | `DISTINCTCOUNT` | Whole_number | `dim_customers` | dimension_table | One row per customer profile | Shopify |
| **Total Active Customer Base** | `SUM` | Whole_number | `dim_customers` | dimension_table | One row per customer profile | Shopify |
| **Channel Reported Revenue** | `SUM` | Currency | `fact_marketing_performance` | transaction_fact | One row per day, per unique ad creative | Google Ads, Meta Ads, TikTok Ads |
| **Average Order Value (AOV)** | `AVERAGE` | Currency | `fact_sales_line_items` | transaction_fact | One row per order line item | Shopify |
| **Observed Average Lifetime Orders (LTV)** | `COUNT` | Whole_number | `fact_sales_line_items` | transaction_fact | One row per order line item | Shopify |
| **Total Units Sold** | `SUM` | Whole_number | `fact_sales_line_items` | transaction_fact | One row per order line item | Shopify |
| **Total COGS** | `SUM` | Currency | `fact_sales_line_items` | transaction_fact | One row per order line item | Shopify |

## 3. Executive KPIs & DAX Formulas
| KPI Name | Business Definition | DAX Formula | Target Benchmark | Owner Role |
| :--- | :--- | :--- | :--- | :--- |
| **Net Sales** | Calculates true realized top-line revenue after all promo deductions and returned goods | `[Net Sales] = [Gross Order Value] - [Total Discount Amount] - [Total Return Amount]` | `$1.25M Monthly` | CFO / Finance Operations |
| **Channel ROAS** | Evaluates return on ad spend at the isolated ad network level for tactical campaign optimization | `[Channel ROAS] = DIVIDE([Channel Reported Revenue], [Total Ad Spend], 0)` | `3.5x` | Paid Acquisition Lead |
| **Marketing Efficiency Ratio (MER)** | Executive North Star metric measuring total marketing efficiency against bank account net revenue | `[MER] = DIVIDE([Net Revenue], [Total Ad Spend], 0)` | `4.0x Blended` | CMO (Chief Marketing Officer) |
| **Blended CAC** | Measures the fully-blended cost to acquire a single net-new paying customer | `[Blended CAC] = DIVIDE([Total Ad Spend], [Total New Customers Acquired], 0)` | `$45.00` | Growth Marketing Director |
| **Observed Average Customer LTV** | Establishes long-term customer monetization potential to validate allowable acquisition costs | `Observed Average Customer LTV = AVERAGE(dim_customers[total_observed_lifetime_spend])` | `$135.00 (3:1 LTV:CAC Ratio)` | VP of Customer Retention |
| **Click-Through Rate (CTR)** | Measures people who clicked on the ad compared to the amount of people who viewed it | `DIVIDE([Total Clicks], [Total Impressions], 0)` | `>1.5-3% Depending on Channel` | CMO / CFO |
| **Cost Per Click (CPC)** | Measures cost per click received | `DIVIDE([Total Spend], [Total Clicks], 0)` | `<$0.8-$2.50 Depending on Channel` | CMO / CFO |
| **Marketing Profit** | Profit generated during the data period (1 year data period) | `Marketing Profit = [Net Sales] - [Total Ad Spend]` | `> $0.00` | CMO / CFO |
| **Baseline Marketing Profit** | Profit generated during the baseline period prior to scaling the marketing campaigns | `Baseline Marketing Profit =CALCULATE(     [Marketing Profit],     DATESBETWEEN(dim_date[full_date], DATE(2025, 7, 1), DATE(2025, 12, 31)) )` | `> $0.00` | CMO / CFO |
| **Campaign Scaling Marketing Profit** | Profit generated during the period of scaling the marketing campaigns | `Campaign Scaling Marketing Profit =CALCULATE(     [Marketing Profit],     DATESBETWEEN(dim_date[full_date], DATE(2026, 1, 1), DATE(2026, 6, 30)) )` | `> $0.00` | CMO / CFO |
| **Incremental Marketing Profit** | Profit generated by scaling ad spend compared to historical pre-scaling baselines | `Incremental Marketing Profit =[Campaign Marketing Profit] - [Baseline Marketing Profit]` | `> $0.00` | CMO / CFO |
| **Incremental Profit Growth %** | Growth % due to marketing campaign scaling | `DIVIDE([Incremental Marketing Profit], [Baseline Profit (H1)], 0)` | `> 0%` | CMO / CFO |
| **Total Returning Customers** | Total Returning Customers | `[Total Active Customer Base] - [Total New Customers Acquired]` | `> 0` | CMO / CFO |
| **New Customer Acquisition %** | New Customer Acquisition % | `DIVIDE([Total New Customers Acquired], [Total Active Customer Base], 0)` | `> 0%` | CMO / CFO |
| **Returning Customer %** | Percent customers returning to place orders | `DIVIDE([Total Returning Customers], [Total Active Customer Base], 0)` | `>0` | CMO / CFO |
| **Gross Profit** | Profit generated after subtracting discount amount, return amount, and COGS | `Gross Profit =  [Net Sales] - [Total COGS]` | `$0.9M Monthly` | CMO / CFO |
| **Gross Margin** | percentage of revenue (net sales) after subtracting cost of good sold | `Gross Margin % =  DIVIDE([Gross Profit], [Net Sales], 0)` | `>60%` | CMO / CFO |
| **Marketing Profit Margin** | Marketing profit generated as a percentage of net sales | `Marketing Profit Margin % =  DIVIDE([Marketing Contribution], [Net Sales], 0)` | `>30%` | CMO / CFO |

## 4. Shared Dimensions Catalog
### `dim_customers` (Standard)
* **Grain:** One row per unique customer profile
* **Attributes:** customer_id, customer_email_hash, first_name, last_name, first_order_date, total_lifetime_orders, customer_segment, country, region
* **Example Values:** CUST-9012, e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855, Jane, Doe, 2025-11-14, 3, VIP, USA, North America

### `dim_calendar` (Time)
* **Grain:** One row per date
* **Attributes:** date_key, full_date, day_of_week, day_name, week_of_year, month_number, month_name, quarter, fiscal_year, is_weekend, is_holiday
* **Example Values:** 20260806, 2026-08-06, 4, Thursday, 32, 8, August, Q3, 2026, FALSE, FALSE

### `dim_products` (Standard)
* **Grain:** One row per unique product variation / SKU
* **Attributes:** product_id, sku, product_name, category, subcategory, unit_cost, retail_price, color, size, is_active
* **Example Values:** PROD-104, APX-JKT-RED-M, Alpine Pro Shell Jacket, Apparel, Outerwear, 62.50, 189.00, Crimson Red, Medium, TRUE

### `dim_ad_campaigns` (Standard)
* **Grain:** One row per ad
* **Attributes:** ad_id, ad_name, ad_set_id, ad_set_name, campaign_id, campaign_name, channel_name, ad_type, target_audience
* **Example Values:** AD-8842, Video_RedJacket_15s, SET-402, US_Lookalike_1%_Outdoor, CAMP-109, Q3_Winter_Gear_Launch, Meta Ads, Video, Outdoor Enthusiasts

### `dim_channels` (Standard)
* **Grain:** One row per channel
* **Attributes:** channel_id, channel_name, channel_group, attribution_type, primary_platform_owner
* **Example Values:** CHAN-01, Meta Ads, Paid Social, Position-Based / Multi-Touch, Paid Acquisition Lead

## 5. Field-Level ETL & Data Cleaning Contracts
| Target Field | Source System | Raw Source Field | Cleaning Category | Transformation Rule | Validation Rule |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `fact_marketing_performance.Total Ad Spend` | Meta Ads | `spend` | `currency_numeric` | COALESCE(CAST(raw_field AS NUMERIC(18,2)), 0.00) | `Value >= 0.00` |
| `fact_marketing_performance.Ad Impressions` | Meta Ads | `impressions` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `fact_marketing_performance.Ad Clicks` | Meta Ads | `clicks` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `fact_web_traffic.Total Web Sessions` | Google Analytics 4 (GA4) | `sessions` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `fact_web_traffic.Unique Site Visitors` | Google Analytics 4 (GA4) | `totalUsers` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `fact_web_traffic.Total Add-to-Carts` | Google Analytics 4 (GA4) | `addToCarts` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `fact_sales_line_items.Gross Order Value` | Shopify | `total_price` | `currency_numeric` | COALESCE(CAST(raw_field AS NUMERIC(18,2)), 0.00) | `Value >= 0.00` |
| `fact_sales_line_items.Total Discount Amount` | Shopify | `total_discounts` | `currency_numeric` | COALESCE(CAST(raw_field AS NUMERIC(18,2)), 0.00) | `Value >= 0.00` |
| `fact_sales_line_items.Total Return Amount` | Shopify | `refund_amount` | `currency_numeric` | COALESCE(CAST(raw_field AS NUMERIC(18,2)), 0.00) | `Value >= 0.00` |
| `fact_sales_line_items.Total Orders Count` | Shopify | `id` | `primary_key` | Text.Trim([raw_field]) \| CAST(raw_field AS STRING) | `NOT NULL AND NOT BLANK` |
| `dim_customers.Total New Customers Acquired` | Shopify | `customer_id` | `primary_key` | Text.Trim([raw_field]) \| CAST(raw_field AS STRING) | `NOT NULL AND NOT BLANK` |
| `dim_customers.Total Active Customer Base` | Shopify | `customer_id` | `primary_key` | Text.Trim([raw_field]) \| CAST(raw_field AS STRING) | `NOT NULL AND NOT BLANK` |
| `fact_marketing_performance.Channel Reported Revenue` |  | `` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `fact_sales_line_items.Average Order Value (AOV)` |  | `` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `fact_sales_line_items.Observed Average Lifetime Orders (LTV)` |  | `` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `fact_sales_line_items.Total Units Sold` |  | `` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `fact_sales_line_items.Total COGS` |  | `` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_customers.customer_id` | Shopify | `id` | `primary_key` | Text.Trim([raw_field]) \| CAST(raw_field AS STRING) | `NOT NULL AND NOT BLANK` |
| `dim_customers.customer_email_hash` | Shopify | `email` | `pii_hash` | LOWER(TRIM(raw_field)) -> SHA256 Hash | `Valid 64-Character String` |
| `dim_customers.first_name` | Shopify | `first_name` | `text_clean` | TRIM(UPPER(raw_field)) | `NOT NULL` |
| `dim_customers.last_name` | Shopify | `last_name` | `text_clean` | TRIM(UPPER(raw_field)) | `NOT NULL` |
| `dim_customers.first_order_date` | Shopify | `order_date` | `date_key` | CAST(FORMAT_DATE('%Y%m%d', raw_field) AS INT64) | `Valid YYYYMMDD Integer Key` |
| `dim_customers.total_lifetime_orders` | Shopify | `orders_count` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_customers.customer_segment` | Shopify | `tags` | `text_clean` | TRIM(UPPER(raw_field)) | `NOT NULL` |
| `dim_customers.country` | Shopify | `default_address.country` | `text_clean` | TRIM(UPPER(raw_field)) | `NOT NULL` |
| `dim_customers.region` | Shopify | `default_address.province` | `text_clean` | TRIM(UPPER(raw_field)) | `NOT NULL` |
| `dim_calendar.date_key` | Shopify | `date` | `date_key` | CAST(FORMAT_DATE('%Y%m%d', raw_field) AS INT64) | `Valid YYYYMMDD Integer Key` |
| `dim_calendar.full_date` | Shopify | `date` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_calendar.day_of_week` | Shopify | `date` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_calendar.day_name` | Shopify | `date` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_calendar.week_of_year` | Shopify | `date` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_calendar.month_number` | Shopify | `date` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_calendar.month_name` | Shopify | `date` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_calendar.quarter` | Shopify | `date` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_calendar.fiscal_year` | Shopify | `date` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_calendar.is_weekend` | Shopify | `date` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_calendar.is_holiday` | Shopify | `date` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_products.product_id` | Shopify | `product_id` | `primary_key` | Text.Trim([raw_field]) \| CAST(raw_field AS STRING) | `NOT NULL AND NOT BLANK` |
| `dim_products.sku` | Shopify | `sku` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_products.product_name` | Shopify | `title` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_products.category` | Shopify | `product_type` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_products.subcategory` | Shopify | `tags` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_products.unit_cost` | Shopify | `cost` | `currency_numeric` | COALESCE(CAST(raw_field AS NUMERIC(18,2)), 0.00) | `Value >= 0.00` |
| `dim_products.retail_price` | Shopify | `price` | `currency_numeric` | COALESCE(CAST(raw_field AS NUMERIC(18,2)), 0.00) | `Value >= 0.00` |
| `dim_products.color` | Shopify | `option1` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_products.size` | Shopify | `option2` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_products.is_active` | Shopify | `status` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_ad_campaigns.ad_id` | Meta Ads | `ad_id` | `primary_key` | Text.Trim([raw_field]) \| CAST(raw_field AS STRING) | `NOT NULL AND NOT BLANK` |
| `dim_ad_campaigns.ad_name` | Meta Ads | `ad_name` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_ad_campaigns.ad_set_id` | Meta Ads | `adset_id` | `primary_key` | Text.Trim([raw_field]) \| CAST(raw_field AS STRING) | `NOT NULL AND NOT BLANK` |
| `dim_ad_campaigns.ad_set_name` | Meta Ads | `adset_name` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_ad_campaigns.campaign_id` | Meta Ads | `campaign_id` | `primary_key` | Text.Trim([raw_field]) \| CAST(raw_field AS STRING) | `NOT NULL AND NOT BLANK` |
| `dim_ad_campaigns.campaign_name` | Meta Ads | `campaign_name` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_ad_campaigns.channel_name` | Meta Ads | `publisher_platform` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_ad_campaigns.ad_type` | Meta Ads | `objective` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_ad_campaigns.target_audience` | Meta Ads | `targeting` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_channels.channel_id` | Google Analytics 4 (GA4) | `sessionDefaultChannelGroup` | `primary_key` | Text.Trim([raw_field]) \| CAST(raw_field AS STRING) | `NOT NULL AND NOT BLANK` |
| `dim_channels.channel_name` | Google Analytics 4 (GA4) | `sessionSourceMedium` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_channels.channel_group` | Google Analytics 4 (GA4) | `sessionDefaultChannelGroup` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_channels.attribution_type` | Google Analytics 4 (GA4) | `attributionModel` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |
| `dim_channels.primary_platform_owner` | Google Analytics 4 (GA4) | `source` | `pass_through` | Pass-Through / Direct Copy | `None / Direct Copy` |

