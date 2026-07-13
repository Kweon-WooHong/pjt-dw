INSERT INTO LRM.LRC401P (STND_DATE
                       , JOB_DAY_CLS_CODE
                       , PSTN_ID
                       , PSTN_SRC_CLS_CODE
                       , PSTN_SRNO
                       , RMCOA_CODE
                       , OCRN_DATE
                       , MTRT_DATE
                       , PSTN_CLS_CODE
                       , PAY_RCVN_CLS_CODE
                       , CRNC_CODE
                       , CSFL_OCRN_AMT
                       , PSTN_DVSN_RATE
                       , BS_VRFC_STND_AMT
                       , PROC_PGM_ID
                       , PROC_DT
                                )
    SELECT A.STND_DATE
         , A.JOB_DAY_CLS_CODE
         , A.PSTN_ID
         , '40'                 AS PSTN_SRC_CLS_CODE
         , 1                    AS PSTN_SRNO
         , NULL                 AS RMCOA_CODE
         , NULL                 AS OCRN_DATE
         , A.MTRT_DATE
         , '00'                 AS PSTN_CLS_CODE
         , NULL                 AS PAY_RCVN_CLS_CODE
         , A.CRNC_CODE
         , CASE WHEN ACIT_CLS_CODE IN ('11', '21') THEN A.VLTN_AMT
                ELSE -1 * A.VLTN_AMT END AS CSFL_OCRN_AMT
         , NULL                 AS PSTN_DVSN_RATE
         , NULL                 AS BS_VRFC_STND_AMT
         , :v_program_id        AS PROC_PGM_ID
         , SYSDATE              AS PROC_DT
      FROM LRM.LRP110L A
         , LRM.LRP100P B
         , LRM.LRM030L C
     WHERE A.STND_DATE = :i_stnd_date
       AND A.JOB_DAY_CLS_CODE = :i_job_day_cls_code
       AND A.MRKT_SCNR_CODE = (SELECT SYS_STUP_ITEM_VAL01 AS DFLT_MRKT_SCNR_CODE
                                 FROM LRM.LRS911L
                                WHERE STND_DATE = :i_stnd_date
                                  AND SYS_STUP_CODE = 'SYS_DFLT_VAL'
                                  AND SYS_STUP_ITEM_CODE = 'DFLT_MRKT_SCNR_CODE')
       AND A.STND_DATE = B.STND_DATE
       AND A.JOB_DAY_CLS_CODE = B.JOB_DAY_CLS_CODE
       AND A.PSTN_ID = B.PSTN_ID
       AND B.STND_DATE = C.STND_DATE
       AND B.JOB_DAY_CLS_CODE = C.JOB_DAY_CLS_CODE
       AND B.ACIT_CODE = C.ACIT_CODE
;
