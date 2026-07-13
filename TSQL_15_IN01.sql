INSERT INTO LRM.LRC433T (STND_DATE
                       , JOB_DAY_CLS_CODE
                       , PRCS_CODE
                       , CSFL_CLS_CODE
                       , CMTT_TRGT_CRNC_CLS_CODE
                       , SCNR_CODE
                       , MSRMVAL_CLS_CODE
                       , RPT_ITEM_CODE
                       , TMBC_CODE
                       , MSRMVAL_SMPL_VAL
                                    )
    WITH DRTN_AMT_SRC AS (  -- 듀레이션 금액
                          SELECT  STND_DATE
                                , JOB_DAY_CLS_CODE
                                , PRCS_CODE
                                , CSFL_CLS_CODE
                                , CMTT_TRGT_CRNC_CLS_CODE
                                , SCNR_CODE
                                , MSRMVAL_CLS_CODE
                                , RPT_ITEM_CODE
                                , TMBC_CODE
                                , MSRMVAL_SMPL_VAL AS DRTN_AMT  /* 측정치_값 = 듀레이션 금액 */
                             FROM LRM.LRC433T
                            WHERE STND_DATE = :i_stnd_date
                              AND JOB_DAY_CLS_CODE = :i_job_day_cls_code
                              AND MSRMVAL_CLS_CODE = '14'  /* 듀레이션 금액 */
                                                         ),
        PV_SRC AS (  -- PV 금액
                   SELECT  STND_DATE
                         , JOB_DAY_CLS_CODE
                         , PRCS_CODE
                         , CSFL_CLS_CODE
                         , CMTT_TRGT_CRNC_CLS_CODE
                         , SCNR_CODE
                         , MSRMVAL_CLS_CODE
                         , RPT_ITEM_CODE
                         , TMBC_CODE
                         , MSRMVAL_SMPL_VAL AS PV_AMT  /* 측정치_값 = PV 금액 */
                      FROM LRM.LRC433T
                     WHERE STND_DATE = :i_stnd_date
                       AND JOB_DAY_CLS_CODE = :i_job_day_cls_code
                       AND MSRMVAL_CLS_CODE = '12'  /* PV 금액 */
                                                  )
    SELECT A.STND_DATE
         , A.JOB_DAY_CLS_CODE
         , A.PRCS_CODE
         , A.CSFL_CLS_CODE
         , A.CMTT_TRGT_CRNC_CLS_CODE
         , A.SCNR_CODE
         , '13' AS MSRMVAL_CLS_CODE  /* 측정치_구분_코드 = 듀레이션(13) */
         , A.RPT_ITEM_CODE
         , A.TMBC_CODE
         , CASE
               WHEN B.PV_AMT IS NULL
                 OR B.PV_AMT = 0 THEN
                   0
               ELSE
                   A.DRTN_AMT / B.PV_AMT
           END
               AS MSRMVAL  /* 측정치 = 듀레이션 */
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
