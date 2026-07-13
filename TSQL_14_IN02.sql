INSERT INTO LRM.LRC411T (STND_DATE
                       , JOB_DAY_CLS_CODE
                       , PSTN_ID
                       , CSFL_CLS_CODE
                       , PSTN_FNDT_SRNO
                       , RMCOA_CODE
                       , PSTN_SRC_CLS_CODE
                       , PSTN_EXTR_CLS_CODE
                       , USE_CLS_CODE
                       , MTRT_DTRM_MTHD_CODE
                       , MTRT_DTRM_STUP_NO
                       , OCRN_DATE
                       , MTRT_DATE
                       , PSTN_CLS_CODE
                       , PAY_RCVN_CLS_CODE
                       , CRNC_CODE
                       , CSFL_OCRN_AMT
                       , PSTN_DVSN_RATE
                       , BS_VRFC_STND_AMT
                                         )
    WITH RMCOA_CSFL_SRC AS
            (
             SELECT RMCOA_CODE
                  , CSFL_CLS_CODE
                  --------------------
                  , USE_CLS_CODE
                  , CASE WHEN USE_CLS_CODE = '01' THEN 1 ELSE -1 END AS AMT_DRCT_MLTL
                  , PSTN_EXTR_CLS_CODE
                  , '40' AS EXTR_TRGT_SRC_CLS_CODE
                  , MTRT_DTRM_MTHD_CODE
                  , MTRT_DTRM_STUP_NO
               FROM LRM.LRA311T
              WHERE STND_DATE = :i_stnd_date
                AND JOB_DAY_CLS_CODE = :i_job_day_cls_code
                AND USE_CLS_CODE <> '03'
                AND PSTN_EXTR_CLS_CODE IN ('32', '33') -- 시장CF 누락분 : '32'(시장CF_시장평가), '33'(시장CF_종합)
                                                      ),
        FNDT_PSTN_SRC AS (
                          SELECT A.STND_DATE
                               , A.JOB_DAY_CLS_CODE
                               , A.PSTN_ID
                               , B.CSFL_CLS_CODE
                               , A.PSTN_SRNO AS PSTN_FNDT_SRNO
                               ---------------
                               , A.RMCOA_CODE
                               , A.PSTN_SRC_CLS_CODE
                               , B.PSTN_EXTR_CLS_CODE
                               , B.USE_CLS_CODE
                               , B.MTRT_DTRM_MTHD_CODE
                               , B.MTRT_DTRM_STUP_NO
                               , A.OCRN_DATE
                               , A.MTRT_DATE
                               , A.PSTN_CLS_CODE
                               , A.PAY_RCVN_CLS_CODE
                               , A.CRNC_CODE
                               , A.CSFL_OCRN_AMT * B.AMT_DRCT_MLTL AS CSFL_OCRN_AMT
                               , A.PSTN_DVSN_RATE
                               , A.BS_VRFC_STND_AMT
                            FROM LRM.LRC401T A
                               , RMCOA_CSFL_SRC B
                           WHERE A.STND_DATE = :i_stnd_date
                             AND A.JOB_DAY_CLS_CODE = :i_job_day_cls_code
                             AND A.RMCOA_CODE = B.RMCOA_CODE
                             AND A.PSTN_SRC_CLS_CODE = B.EXTR_TRGT_SRC_CLS_CODE)
      SELECT A.*
        FROM FNDT_PSTN_SRC A
           , LRM.LRC411T B
       WHERE A.STND_DATE = B.STND_DATE(+)
         AND A.JOB_DAY_CLS_CODE = B.JOB_DAY_CLS_CODE(+)
         AND A.PSTN_ID = B.PSTN_ID(+)
         AND A.CSFL_CLS_CODE = B.CSFL_CLS_CODE(+)
         AND B.PSTN_FNDT_SRNO IS NULL
    ORDER BY A.CSFL_CLS_CODE
           , A.RMCOA_CODE
;

