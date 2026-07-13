INSERT INTO LRM.LRC430T (STND_DATE
                       , JOB_DAY_CLS_CODE
                       , PRCS_CODE
                       , CSFL_CLS_CODE
                       , CMTT_TRGT_CRNC_CLS_CODE
                       , SCNR_CODE
                       , MSRMVAL_CLS_CODE
                       , RPT_ITEM_CODE
                       , TMBC_CODE
                       , MSRMVAL_SMPL_VAL
                       , HGRN_RPT_ITEM_CODE
                       , LEVL_NO
                       , SORT_SEQ_NO
                       , LAST_LEVL_YN
                                     )
    WITH DRTN_AMT_SRC AS (  -- 듀레이션_금액
                          SELECT   STND_DATE
                                 , JOB_DAY_CLS_CODE
                                 , PRCS_CODE
                                 , CSFL_CLS_CODE
                                 , CMTT_TRGT_CRNC_CLS_CODE
                                 , SCNR_CODE
                                 , MSRMVAL_CLS_CODE
                                 , RPT_ITEM_CODE
                                 , TMBC_CODE
                                 , NVL (SUM (MSRMVAL_VAL), 0) AS DRTN_AMT  /* 측정치_값 = 듀레이션 금액 */
                                 , MAX (HGRN_RPT_ITEM_CODE) AS HGRN_RPT_ITEM_CODE
                                 , MAX (LEVL_NO) AS LEVL_NO
                                 , MAX (SORT_SEQ_NO) AS SORT_SEQ_NO
                                 , MAX (LAST_LEVL_YN) AS LAST_LEVL_YN
                              FROM (SELECT STND_DATE
                                         , JOB_DAY_CLS_CODE
                                         , PRCS_CODE
                                         , CSFL_CLS_CODE
                                         , CMTT_TRGT_CRNC_CLS_CODE
                                         , SCNR_CODE
                                         , MSRMVAL_CLS_CODE
                                         , RPT_ITEM_CODE
                                         , TMBC_CODE
                                         , MSRMVAL_SMPL_VAL  AS MSRMVAL_VAL
                                         , HGRN_RPT_ITEM_CODE
                                         , LEVL_NO
                                         , SORT_SEQ_NO
                                         , LAST_LEVL_YN
                                      FROM LRM.LRC434T  -- 상위 항목의 기존 측정치
                                     WHERE MSRMVAL_CLS_CODE = '14' /* 듀레이션_금액 */
                                    UNION ALL
                                    SELECT STND_DATE
                                         , JOB_DAY_CLS_CODE
                                         , PRCS_CODE
                                         , CSFL_CLS_CODE
                                         , CMTT_TRGT_CRNC_CLS_CODE
                                         , SCNR_CODE
                                         , MSRMVAL_CLS_CODE
                                         , RPT_ITEM_CODE
                                         , TMBC_CODE
                                         , MSRMVAL_SMPL_VAL  AS MSRMVAL_VAL
                                         , HGRN_RPT_ITEM_CODE
                                         , LEVL_NO
                                         , SORT_SEQ_NO
                                         , LAST_LEVL_YN
                                      FROM LRM.LRC433T  -- 하위 항목의 산출 측정치
                                     WHERE MSRMVAL_CLS_CODE = '14'  /* 듀레이션_금액 */
                                                                  ) A
                          GROUP BY STND_DATE
                                 , JOB_DAY_CLS_CODE
                                 , PRCS_CODE
                                 , CSFL_CLS_CODE
                                 , CMTT_TRGT_CRNC_CLS_CODE
                                 , SCNR_CODE
                                 , MSRMVAL_CLS_CODE
                                 , RPT_ITEM_CODE
                                 , TMBC_CODE),
        PV_SRC AS (  -- PV_금액
                   SELECT   STND_DATE
                          , JOB_DAY_CLS_CODE
                          , PRCS_CODE
                          , CSFL_CLS_CODE
                          , CMTT_TRGT_CRNC_CLS_CODE
                          , SCNR_CODE
                          , MSRMVAL_CLS_CODE
                          , RPT_ITEM_CODE
                          , TMBC_CODE
                          , NVL (SUM (MSRMVAL_VAL), 0) AS PV_AMT  /* 측정치_값 = PV 금액 */
                          , MAX (HGRN_RPT_ITEM_CODE) AS HGRN_RPT_ITEM_CODE
                          , MAX (LEVL_NO) AS LEVL_NO
                          , MAX (SORT_SEQ_NO) AS SORT_SEQ_NO
                          , MAX (LAST_LEVL_YN) AS LAST_LEVL_YN
                       FROM (SELECT STND_DATE
                                  , JOB_DAY_CLS_CODE
                                  , PRCS_CODE
                                  , CSFL_CLS_CODE
                                  , CMTT_TRGT_CRNC_CLS_CODE
                                  , SCNR_CODE
                                  , MSRMVAL_CLS_CODE
                                  , RPT_ITEM_CODE
                                  , TMBC_CODE
                                  , MSRMVAL_SMPL_VAL  AS MSRMVAL_VAL
                                  , HGRN_RPT_ITEM_CODE
                                  , LEVL_NO
                                  , SORT_SEQ_NO
                                  , LAST_LEVL_YN
                               FROM LRM.LRC434T  -- 상위 항목의 기존 측정치
                              WHERE MSRMVAL_CLS_CODE = '12' /* PV_금액 */
                             UNION ALL
                             SELECT STND_DATE
                                  , JOB_DAY_CLS_CODE
                                  , PRCS_CODE
                                  , CSFL_CLS_CODE
                                  , CMTT_TRGT_CRNC_CLS_CODE
                                  , SCNR_CODE
                                  , MSRMVAL_CLS_CODE
                                  , RPT_ITEM_CODE
                                  , TMBC_CODE
                                  , MSRMVAL_SMPL_VAL  AS MSRMVAL_VAL
                                  , HGRN_RPT_ITEM_CODE
                                  , LEVL_NO
                                  , SORT_SEQ_NO
                                  , LAST_LEVL_YN
                               FROM LRM.LRC433T  -- 하위 항목의 산출 측정치
                              WHERE MSRMVAL_CLS_CODE = '12'  /* PV_금액 */
                                                           ) A
                   GROUP BY STND_DATE
                          , JOB_DAY_CLS_CODE
                          , PRCS_CODE
                          , CSFL_CLS_CODE
                          , CMTT_TRGT_CRNC_CLS_CODE
                          , SCNR_CODE
                          , MSRMVAL_CLS_CODE
                          , RPT_ITEM_CODE
                          , TMBC_CODE)
    SELECT A.STND_DATE
         , A.JOB_DAY_CLS_CODE
         , A.PRCS_CODE
         , A.CSFL_CLS_CODE
         , A.CMTT_TRGT_CRNC_CLS_CODE
         , A.SCNR_CODE
         , '13' AS MSRMVAL_CLS_CODE   /* 측정치_구분_코드 = 듀레이션(13) */
         , A.RPT_ITEM_CODE
         , A.TMBC_CODE
         , CASE
               WHEN B.PV_AMT IS NULL
                 OR B.PV_AMT = 0 THEN
                   0
               ELSE
                   A.DRTN_AMT / B.PV_AMT
           END
               AS HGRN_RPT_ITEM_CODE   /* 측정치_단순_값 = 듀레이션 */
         , A.HGRN_RPT_ITEM_CODE
         , A.LEVL_NO
         , A.SORT_SEQ_NO
         , A.LAST_LEVL_YN
      FROM DRTN_AMT_SRC A  -- 듀레이션 금액
         , PV_SRC       B  -- PV 금액
     WHERE A.STND_DATE = B.STND_DATE
       AND A.JOB_DAY_CLS_CODE = B.JOB_DAY_CLS_CODE
       AND A.PRCS_CODE = B.PRCS_CODE
       AND A.CSFL_CLS_CODE = B.CSFL_CLS_CODE
       AND A.CMTT_TRGT_CRNC_CLS_CODE = B.CMTT_TRGT_CRNC_CLS_CODE
       AND A.SCNR_CODE = B.SCNR_CODE
       AND A.RPT_ITEM_CODE = B.RPT_ITEM_CODE
       AND A.TMBC_CODE = B.TMBC_CODE
;