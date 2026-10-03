/* =========================================================================
  E-Commerce Marketing & LTV Analytics
  
 dim_channels Table Power Query Data Cleaning
   ========================================================================= */

let
    Source = Table.Combine({additional_channels, dim_channels_staging}),
    #"Sorted Rows" = Table.Sort(Source,{{"channel_id", Order.Ascending}})
in
    #"Sorted Rows"