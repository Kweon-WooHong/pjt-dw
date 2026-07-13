INSERT INTO LRM.LRA301L (STND_DATE                    /* 기준_일자 */
                       , JOB_DAY_CLS_CODE             /* 작업_일_구분_코드 */
                       , RMCOA_ATRB_CODE              /* RMCoA_속성_코드 */
                       , RMCOA_ATRB_VAL_CODE          /* RMCoA_속성_값_코드 */
                       , RMCOA_ATRB_VAL_NAME          /* RMCoA_속성_값_명 */
                       , STA_STND_APLY_CODE           /* 시작_기준_적용_코드 */
                       , STA_STND_VAL                 /* 시작_기준_값 */
                       , FIN_STND_APLY_CODE           /* 종료_기준_적용_코드 */
                       , FIN_STND_VAL                 /* 종료_기준_값 */
                       , RMCOA_ATRB_VAL_EXPL          /* RMCoA_속성_값_설명 */
                       , PROC_PGM_ID                  /* 처리_프로그램_ID */
                       , PROC_DT                      /* 처리_일시 */
                                )
      SELECT STND_DATE                                /* 기준_일자 */
           , JOB_DAY_CLS_CODE                         /* 작업_일_구분_코드 */
           , RMCOA_ATRB_CODE                          /* RMCoA_속성_코드 */
           , RMCOA_ATRB_VAL_CODE                      /* RMCoA_속성_값_코드 */
           , RMCOA_ATRB_VAL_NAME                      /* RMCoA_속성_값_명 */
           , STA_STND_APLY_CODE                       /* 시작_기준_적용_코드 */
           , STA_STND_VAL                             /* 시작_기준_값 */
           , FIN_STND_APLY_CODE                       /* 종료_기준_적용_코드 */
           , FIN_STND_VAL                             /* 종료_기준_값 */
           , RMCOA_ATRB_VAL_EXPL                      /* RMCoA_속성_값_설명 */
           , :v_program_id          AS PROC_PGM_ID    /* 처리_프로그램_ID */
           , SYSDATE                AS PROC_DT        /* 처리_일시 */
        FROM LRM.LRA301T
       WHERE STND_DATE = :i_stnd_date
         AND JOB_DAY_CLS_CODE = :i_job_day_cls_code
    ORDER BY RMCOA_ATRB_CODE
           , RMCOA_ATRB_VAL_CODE
;