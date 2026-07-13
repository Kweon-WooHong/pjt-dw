INSERT INTO LRM.LRC401P (STND_DATE                                                   /* 기준_일자 */
                       , JOB_DAY_CLS_CODE                                    /* 작업_일_구분_코드 */
                       , PSTN_ID                                                     /* 포지션_ID */
                       , PSTN_SRC_CLS_CODE                               /* 포지션_원천_구분_코드 */
                       , PSTN_SRNO                                             /* 포지션_일련번호 */
                       , RMCOA_CODE                                                 /* RMCoA_코드 */
                       , OCRN_DATE                                                   /* 발생_일자 */
                       , MTRT_DATE                                                   /* 만기_일자 */
                       , PSTN_CLS_CODE                                        /* 포지션_구분_코드 */
                       , PAY_RCVN_CLS_CODE                                 /* 지급_수취_구분_코드 */
                       , CRNC_CODE                                                   /* 통화_코드 */
                       , CSFL_OCRN_AMT                                      /* 현금흐름_발생_금액 */
                       , PSTN_DVSN_RATE                                       /* 포지션_분할_비율 */
                       , BS_VRFC_STND_AMT                                    /* BS_대사_기준_금액 */
                       , PROC_PGM_ID                                          /* 처리_프로그램_ID */
                       , PROC_DT                                                     /* 처리_일시 */
                                )
    WITH BS_BAL_SRC AS                                                                 /* BS 잔액 */
                      (SELECT STND_DATE                                              /* 기준_일자 */
                            , :i_job_day_cls_code AS JOB_DAY_CLS_CODE        /* 작업_일_구분_코드 */
                            , ACIT_CODE                                          /* 계정과목_코드 */
                            , BS_BAL                                                   /* BS_잔액 */
                         FROM LRM.LRM031L
                        WHERE STND_DATE = :i_stnd_date
                          AND :i_job_day_cls_code = 'D'
                       UNION ALL
                       SELECT STND_DATE                                              /* 기준_일자 */
                            , :i_job_day_cls_code AS JOB_DAY_CLS_CODE        /* 작업_일_구분_코드 */
                            , ACIT_CODE                                          /* 계정과목_코드 */
                            , BS_BAL                                                   /* BS_잔액 */
                         FROM LRM.LRM032L
                        WHERE STND_DATE = :i_stnd_date
                          AND :i_job_day_cls_code = 'M'
                          AND BS_BAL_CLS_CODE = 'E'),
        LRP100P_SRC AS                                                           /* RDM BS 포지션 */
                      (SELECT *
                         FROM LRM.LRP100P
                        WHERE STND_DATE = :i_stnd_date
                          AND JOB_DAY_CLS_CODE = :i_job_day_cls_code
                          AND BCDT_OCRN_CLS_CODE IN (SELECT SYS_STUP_ITEM_CODE
                                                       FROM LRM.LRS911L
                                                      WHERE STND_DATE = :i_stnd_date
                                                        AND SYS_STUP_CODE = 'BS_BCDT_OCRN_CLS'))
      SELECT A.STND_DATE                                                             /* 기준_일자 */
           , A.JOB_DAY_CLS_CODE                                              /* 작업_일_구분_코드 */
           , NVL (C.PSTN_ID, A.ACIT_CODE)       AS PSTN_ID                           /* 포지션_ID */
           , '10'                               AS PSTN_SRC_CLS_CODE  /* 포지션_원천_구분_코드 = 10(RDM_BS) */
           , 1                                  AS PSTN_SRNO                   /* 포지션_일련번호 */
           , NULL                               AS RMCOA_CODE                       /* RMCoA_코드 */
           , NVL (C.OCRN_DATE, '')              AS OCRN_DATE                         /* 발생_일자 */
           , NVL (C.MTRT_DATE, '')              AS MTRT_DATE                         /* 만기_일자 */
           , '00'                               AS PSTN_CLS_CODE              /* 포지션_구분_코드 */
           , NULL                               AS PAY_RCVN_CLS_CODE       /* 지급_수취_구분_코드 */
           , NVL (C.CRNC_CODE, (SELECT SYS_STUP_ITEM_VAL01
                                  FROM LRM.LRS911L
                                 WHERE STND_DATE = :i_stnd_date
                                   AND SYS_STUP_CODE = 'SYS_DFLT_VAL'
                                   AND SYS_STUP_ITEM_CODE = 'DFLT_CRNC_CODE'))
                                                AS CRNC_CODE                         /* 통화_코드 */
           , NVL (A.BS_BAL, 0)                  AS CSFL_OCRN_AMT            /* 현금흐름_발생_금액 */
           , NULL                               AS PSTN_DVSN_RATE             /* 포지션_분할_비율 */
           , NULL                               AS BS_VRFC_STND_AMT          /* BS_대사_기준_금액 */
           , :v_program_id                      AS PROC_PGM_ID                /* 처리_프로그램_ID */
           , SYSDATE                            AS PROC_DT                           /* 처리_일시 */
        FROM BS_BAL_SRC A                                                              /* BS 잔액 */
           , LRM.LRM030T B                                                /* 마스터_계정과목임시T */
           , LRP100P_SRC C                                                       /* RDM BS 포지션 */
       WHERE A.STND_DATE = B.STND_DATE
         AND A.JOB_DAY_CLS_CODE = B.JOB_DAY_CLS_CODE
         AND A.ACIT_CODE = B.ACIT_CODE
         AND B.LAST_LEVL_YN = 'Y'
         AND A.STND_DATE = C.STND_DATE(+)
         AND A.JOB_DAY_CLS_CODE = C.JOB_DAY_CLS_CODE(+)
         AND A.ACIT_CODE = C.ACIT_CODE(+)
    ORDER BY A.ACIT_CODE
;