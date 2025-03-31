-- Object name : sap_24000_gl_account

WITH Data_t AS (

SELECT distinct

    bg.bukrs AS company_code
  , belnr AS document_number
  , gjahr AS fiscal_year  
  , augdt AS clearing_date
  , shkzg AS debit_credit_ind 
  , pswbt AS g_l_amount
  , zuonr AS `assignment`
  , hkont AS g_l_account
  , matnr AS material
  , menge AS quantity
  , ebeln AS purchasing_document
  , h_budat AS posting_date
  , h_blart AS document_type
  , CASE WHEN shkzg = "S" THEN PSWBT
    ELSE -(PSWBT)
  END AS net_amount
  , t1.waers AS currency_per_company
  , CASE WHEN shkzg = "S" THEN menge
         ELSE -(menge)
  END AS net_quantity
  , CASE WHEN augdt IS NULL THEN "No"
      ELSE "Yes"
    END AS cleared_after_reporting_date
  , ekgrp AS purchasing_group
  , unsez AS our_reference
  , echo.lifnr AS supplier
  , name1 AS supplier_name
  , operation_flag
  , buzei AS line_number
  , ROW_NUMBER() OVER (PARTITION BY buzei, belnr, gjahr, bg.bukrs ORDER BY bg.recordstamp DESC) AS row_rank

 FROM `bseg` bg 

 LEFT JOIN `t001` t1
    ON bg.bukrs = t1.bukrs AND t1.KTOPL = "RSWG"

  LEFT JOIN `ekko` echo 
    USING(ebeln)

  LEFT JOIN `lfa1` f1
    ON echo.lifnr = f1.lifnr

 WHERE hkont LIKE ANY ("%24000") AND (augdt BETWEEN "2023-12-01" AND CURRENT_DATE() OR augdt IS NULL)
)

, ecco_2 AS (
  SELECT distinct
    our_reference,
    LIFNR AS original_supplier
  FROM Data_t
  INNER JOIN `ekko` ek ON Data_t.our_reference = ek.ebeln
)

  SELECT distinct
    Data_t.* EXCEPT(row_rank, operation_flag, line_number, net_amount)
    , ROUND(CASE WHEN company_code = "5003" THEN 100 * net_amount
                 ELSE net_amount
      END, 2) AS net_amount
    , original_supplier
    , name1 AS orginal_supplier_name
  FROM Data_t

  LEFT JOIN ecco_2 
    USING(our_reference)
  
  LEFT JOIN `lfa1` fa1
    ON ecco_2.original_supplier = fa1.lifnr

  WHERE row_rank = 1
