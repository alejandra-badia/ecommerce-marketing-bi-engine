/* =========================================================================
  E-Commerce Marketing & LTV Analytics
  
  fact_marketing_performance Table Power Query Data Cleaning
   ========================================================================= */

let
    Source = Table.Combine({google_ads_staging, meta_ads_staging, tiktok_ads_staging})
in
    Source