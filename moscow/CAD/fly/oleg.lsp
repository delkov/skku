(defun c:DInfo

  (   /  ;;         --=={ Local Functions }==--          ;

         *error*
         _Display
         dxf
         _GetColour
         ;_GetLW
         _GetName
        ; _GetScale   
         PurgeLayer
         _PutDXF
         ss->lst
         _Stringify
         _Text
         _Update

         ;;         --=={ Local Variables }==--          ;

         -pi/4
         5pi/4
         alignment
         attachment
         celst
         cent
         cobj
         code
         data
         doc
         e
         express
         gr
         inter
         layers
         mode
         modelst
         msg
         msglst
         on
         owner
         pi/4
         r
         rad
         spc
         ss
         telst
         tent
         vs
         x

         ;;         --=={ Global Variables }==--         ;
   
         ; DInfo:Mode    -- Global: Function Number
         ; DInfo:cRad    -- Global: Cursor Aperture

  )

  (vl-load-com)
  

 
  ;;-------------------------------------------------------------------------------;;
  ;;                           --=={  Preliminaries  }==--                         ;;
  ;;-------------------------------------------------------------------------------;;

  (setq spc
    (vlax-get-property
      (setq doc
        (vla-get-ActiveDocument (vlax-get-acad-object))
      )
      (if (= 1 (getvar 'CVPORT)) 'PaperSpace 'ModelSpace)
    )
  )
  
  (vlax-for l (vla-get-layers doc)
    (setq layers (cons l layers))
    (if (eq :vlax-true (vla-get-Layeron l))
      (setq on (cons l on))
    )
  )  
  
  (setq Express
    (and (vl-position "acetutil.arx" (arx))
      (not
        (vl-catch-all-error-p
          (vl-catch-all-apply
            (function (lambda nil (acet-sys-shift-down)))
          )
        )
      )
    )
  )


  (setq ModeLst '("DINFO" "LAYISO"))

  (or DInfo:Mode (setq DInfo:Mode 0))
  (or DInfo:cRad (setq DInfo:cRad 25.0))

  (setq Alignment
    (list
      (cons acAlignmentLeft               "Left"          )
      (cons acAlignmentCenter             "Center"        )
      (cons acAlignmentRight              "Right"         )
      (cons acAlignmentAligned            "Aligned"       )
      (cons acAlignmentMiddle             "Middle"        )
      (cons acAlignmentFit                "Fit"           )
      (cons acAlignmentTopLeft            "Top-Left"      )
      (cons acAlignmentTopCenter          "Top-Center"    )
      (cons acAlignmentTopRight           "Top-Right"     )
      (cons acAlignmentMiddleLeft         "Middle-Left"   )
      (cons acAlignmentMiddleCenter       "Middle-Center" )
      (cons acAlignmentMiddleRight        "Middle-Right"  )
      (cons acAlignmentBottomLeft         "Bottom-Left"   )
      (cons acAlignmentBottomCenter       "Bottom-Center" )
      (cons acAlignmentBottomRight        "Bottom-Right"  )
    )
  )

  (setq Attachment
    (list
      (cons acAttachmentPointTopLeft      "Top-Left"      )
      (cons acAttachmentPointTopCenter    "Top-Center"    )
      (cons acAttachmentPointTopRight     "Top-Right"     )
      (cons acAttachmentPointMiddleLeft   "Middle-Left"   )
      (cons acAttachmentPointMiddleCenter "Middle-Center" )
      (cons acAttachmentPointMiddleRight  "Middle-Right"  )
      (cons acAttachmentPointBottomLeft   "Bottom-Left"   )
      (cons acAttachmentPointBottomCenter "Bottom-Center" )
      (cons acAttachmentPointBottomRight  "Bottom-Right"  )
    )
  )  
  ;;-------------------------------------------------------------------------------;;
  ;;                           --=={  Local Functions  }==--                       ;;
  ;;-------------------------------------------------------------------------------;;

  
  ;;  --=={  Error Handler  }==--
  
  (defun *error* ( msg )
    (if cEnt (entdel cEnt))
    (if tEnt (entdel tEnt))

    (if on (mapcar '(lambda ( x ) (vla-put-layeron x :vlax-true)) on))

    (PurgeLayer "LMAC_DINFO")
    
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Error: " msg " **")))
    (princ)
  )

  ;.................................................................................;

  (defun _PutDXF ( e x r )
    (entmod (subst (cons x r) (assoc x e) e))
  )

  ;.................................................................................;

  (defun _Update ( e )
    (entupd (cdr (assoc -1 e)))
  )

  ;.................................................................................;

  (defun _Text ( tx ) (strcat "{\\fArial|b1|i0|c0|p34;" tx "}"))

  ;.................................................................................;

  (defun ss->lst ( ss / i ent lst )
    (setq i -1)
    (while (setq ent (ssname ss (setq i (1+ i))))
      (setq lst (cons (vlax-ename->vla-object ent) lst))
    )
    lst
  )



  (defun _GetColour ( e / c )    


      "ByLayer"
    
  )

  (defun _GetScale ( e )
    (vl-princ-to-string
      (mapcar
        (function
          (lambda ( x )
            (rtos (dxf x e) (getvar 'LUNITS) 2)
          )
        )
       '(41 42 43)
      )
    )
  )

  ;.................................................................................;

  (defun _GetName ( obj )
    (if (vlax-property-available-p obj 'EffectiveName)
      (vla-get-EffectiveName obj)
      (vla-get-name obj)
    )
  )

  ;.................................................................................;
  
  (defun _GetLW ( e / w )
    (if (setq w (cdr (assoc 370 e)))      
      (cond
        (
          (cdr
            (assoc w
             '(
                (-1 . "ByLayer")
                (-2 . "ByBlock")
                (-3 . "Default")
              )
            )
          )
        )
        ( (strcat (rtos (/ w 100.) 2 2) "mm") )
      )      
      "ByLayer"
    )
  )

  ;.................................................................................;

  (defun _Stringify ( data / typ )
    
    (setq data
      (cond
        ( (eq :vlax-true  data) "Yes" )
        ( (eq :vlax-false data) "No"  )
        ( data )
      )
    )
    
    (cond
      ( (eq 'STR (setq typ (type data)))

        data
      )
      ( (eq 'INT typ)

        (itoa data)
      )
      ( (eq 'REAL typ)

        (rtos data)
      )
      ( (vl-princ-to-string data) )
    )
  )

  ;.................................................................................;


  (defun _Display ( Cir Tx ss mode / cObj cSs iObj aStr iLst tStr cnt tStr )
    (setq cObj (vlax-ename->vla-object Cir) aStr "")
    
    (cond
      (
        (or (not ss) (= (sslength ss) 0))
      )
      ( (setq iObj
          (vl-some
            (function
              (lambda ( obj )
                (if (vlax-invoke obj 'IntersectWith cObj acExtendNone) obj)
              )
            )
            (ss->lst ss)
          )
        )

        (setq iLst (entget (vlax-vla-object->ename iObj)))
        (vla-put-Color cObj acRed)

        (cond
          (
            (zerop mode)

            (cond
              (
                ; (eq "INSERT" (dxf 0 iLst))

                ; (if (setq cSs (ssget "_X" (list (cons 0 "INSERT") (cons 2 (_GetName iObj)))))
                ;   (setq cnt (itoa (sslength cSs)))
                ; )

                ; (if (= 1 (dxf 66 iLst))
                ;   (progn
                ;     (setq aStr "\nATTRIBUTES: \n{\\fArial|b0|i0|c0|p34;")

                ;     (foreach x (vlax-invoke iObj 'GetAttributes)
                ;       (setq aStr (strcat aStr (vla-get-TagString x)  ":  " (vla-get-TextString x) "\n"))
                ;     )
                ;     (setq aStr (strcat aStr "}"))
                ;   )
                ; )



(setq test_max (+ (atoi (vlax-get-property iObj 'Linetype)) 10))
                (setq tStr
                  (strcat
                    ;"{\\C2;"         "Noise level" "}"
                    ;"\nNAME:  "      (_GetName iObj)
                    (if cnt (strcat "\nINSTANCES:  " cnt) "")
                    ;"\nLAYER:  "     (dxf 8 iLst)
                    "\\C10;\nMAX:  "  (itoa (atoi (vlax-get-property iObj 'Linetype)))
                    "\\C2\nEQU:  "     (itoa (+ (atoi (vlax-get-property iObj 'Linetype)) equ_level))

                    ;"\nLINEWEIGHT:  "(_GetLW iLst)
                    ;"\nROTATION:  "  (angtos (dxf 50 iLst))
                    ;"\nSCALE:  "     (_GetScale iLst)
                    ;"\nDYNAMIC: "    (_Stringify (vlax-get-property iObj 'isDynamicBlock))
                    ;"\nXREF:  "      (_Stringify (vlax-get-property (vla-item (vla-get-Blocks doc) (_GetName iObj)) 'ISXREF))
                    aStr
                  )
                )
              )
              (t
                (setq tStr (strcat "{\\C2;" "test" "}"))

                (foreach prop
                 '(
                    ; LAYER
                                         LINETYPE
                     COLOR

                    ; LINEWEIGHT
                    ; ALIGNMENT
                    ; ARCLENGTH
                    ; AREA
                    ; ATTACHMENTPOINT
                    ; CENTER
                    ; CIRCUMFERENCE
                    ; CLOSED
                    ; CUSTOMSCALE
                    ; DEGREE
                    ; DIAMETER
                    ; DISPLAYLOCKED
                    ; ELEVATION
                    ; HEIGHT
                    ; LENGTH
                    ; MEASUREMENT
                    ; OBLIQUEANGLE
                    ; RADIUS
                    ; ROTATION
                    ; SCALEFACTOR
                    ; STYLENAME
                    ; TEXTOVERRIDE
                    ; TEXTSTRING
                    ; TOTALANGLE
                    ; WIDTH
                  )

                  (setq tStr
                    (strcat tStr
                      (if
                        (and
                          (vlax-property-available-p iObj prop)
                          (not (eq "" (vlax-get iObj prop)))
                        )

                        (strcat "\n"
                          (strcase (vl-princ-to-string prop)) ":  "

                          (cond
                            (
                              (eq prop 'COLOR)

                              (_GetColour iLst)
                            )
                            ; (
                            ;   (vl-position prop '(DISPLAYLOCKED CLOSED))

                            ;   (_Stringify (vlax-get-property iObj prop))
                            ; )
                            ; (
                            ;   (eq prop 'ALIGNMENT)

                            ;   (cdr (assoc (vlax-get-property iObj prop) Alignment))
                            ; )
                            ; (
                            ;   (eq prop 'ATTACHMENTPOINT)

                            ;   (cdr (assoc (vlax-get-property iObj prop) Attachment))
                            ; )
                            ; (
                            ;   (or
                            ;     (and
                            ;       (eq 'MEASUREMENT prop)
                            ;       (vl-position (vla-get-ObjectName iObj) '("AcDb2LineAngularDimension" "AcDb3PointAngularDimension"))
                            ;     )
                            ;     (and
                            ;       (eq 'TOTALANGLE prop)
                            ;       (eq "AcDbArc" (vla-get-ObjectName iObj))
                            ;     )
                            ;     (eq 'ROTATION prop)
                            ;   )

                            ;   (angtos (vlax-get iObj prop))
                            ; )
                            ;(
                              ;(eq prop 'LINEWEIGHT)

                              ;(_GetLW iLst)
                            ;)
                            (
                              (_Stringify (vlax-get iObj prop))
                            )
                          )
                        )

                        ""
                      )
                    )
                  )
                )
              )
            )

            (_Update
              (_PutDxf
                (_PutDxf (entget tx) 62 251) 1 (_Text tStr)
              )
            )
            t
          )
        )
      )
      (t )
    )
    
    iObj
  )

  ;.................................................................................;

  (defun dxf ( code lst ) (cdr (assoc code lst)))

  ;.................................................................................;

  (defun PurgeLayer ( layer )
    (if
      (not
        (vl-catch-all-error-p
          (setq layer
            (vl-catch-all-apply 'vla-item
              (list
                (vla-get-layers
                  (vla-get-ActiveDocument (vlax-get-acad-object))
                )
                layer
              )
            )
          )
        )
      )      
      (vl-catch-all-apply 'vla-delete (list layer))
    )
  )

  ;.................................................................................;

  (defun RedrawSS ( ss mode )
    (
      (lambda ( i )
        (while (setq e (ssname ss (setq i (1+ i))))
          (redraw e mode)
        )
      )
      -1
    )
  )

  ;;-------------------------------------------------------------------------------;;
  ;;                           --=={  Main Function  }==--                         ;;
  ;;-------------------------------------------------------------------------------;;

  (setq cEnt
    (entmakex
      (list
        (cons 0 "CIRCLE")
        (cons 8 "LMAC_DINFO")
        (cons 10 (getvar 'VIEWCTR))
        (cons 40 (setq rad (/ (getvar 'VIEWSIZE) (float 10))))
        (cons 62 3)
      )
    )
    cELst (entget cEnt)
  )

  (setq tEnt
    (entmakex
      (list
        (cons 0 "MTEXT")                              
        (cons 100 "AcDbEntity")
        (cons 100 "AcDbMText")
        (cons 8   "LMAC_DINFO")
        ;(cons 1  (_Text (nth DInfo:Mode ModeLst)))
        (cons 10 (getvar 'VIEWCTR))
        (cons 40 (/ (getvar 'VIEWSIZE) 6))
        (cons 50 0.0)
        (cons 62 71)
        (cons 71 1)

        (cons 90 3)
        (cons 63 256)
        (cons 45 1.2)
      )
    )
    tElst (entget tEnt) -pi/4 (/ pi -4.) pi/4 (/ pi 4.) 5pi/4 (/ (* 5 pi) 4.)
  )

  (setq msgLst
   '("\n[+/- Cursor Size]"
     "\n[+/- Cursor Size]"
    )
  )
  
  (princ (setq msg (nth DInfo:Mode msgLst)))

  
  (while
    (progn
      (setq gr (grread 't 15 1) code (car gr) data (cadr gr) vs (getvar 'VIEWSIZE))

      (cond
        (
          (and (= 5 code) (listp data))

          (setq r (sqrt (* 2. rad rad)))

          (setq cEnt
            (_Update
              (setq cELst
                (_PutDxf (_PutDxf cELst 10 data) 40 (setq rad (/ vs (float DInfo:cRad))))
              )
            )
          )

          (setq tEnt
            (_Update
              (setq tELst
                (_PutDxf
                  (_PutDxf tELst 10 (polar (polar data -pi/4 rad) 0 (/ vs 90.0))) 40 (/ vs 60.0)
                )
              )
            )
          )

          (if (setq ss (ssget "_C" (polar data  pi/4 r) (polar data 5pi/4 r)))
            (progn

              (ssdel cEnt ss)
              (ssdel tEnt ss)

              (setq Inter (_Display cEnt tEnt ss DInfo:Mode))
            )
          )

          t
        )
        (
          (= 2 code)

          (cond
            (
              (vl-position data '(43 61))

              (if (> DInfo:cRad 1.0)
                (setq cEnt
                  (_Update
                    (setq cELst
                      (_PutDxf cELst 40
                        (setq rad (/ vs (float (setq DInfo:cRad (1- DInfo:cRad)))))
                      )
                    )
                  )
                )

                (princ (strcat "\n** Maximum Cursor Size Reached **" msg))
              )
            )
            (
              (= 45 data)

              (setq cEnt
                (_Update
                  (setq cELst
                    (_PutDxf cELst 40
                      (setq rad (/ vs (float (setq DInfo:cRad (1+ DInfo:cRad)))))
                    )
                  )
                )
              )
            )
            (
              (= 9 data)

              (setq DInfo:Mode (rem (1+ DInfo:Mode) 2))

              (setq tEnt
                (_Update
                  (setq tELst
                    (_PutDxf tELst 1 (_Text (nth DInfo:Mode ModeLst)))
                  )
                )
              )

              (princ (setq msg (nth DInfo:Mode msgLst)))
            )
            (
              (vl-position data '(13 32)) nil
            )
            ( t )
          )
        )
        (
          (and (= 3 code) (listp data) (= 1 DInfo:Mode))

          (if (and Express (acet-sys-shift-down))
            (mapcar
              (function
                (lambda ( x ) (vla-put-layeron x :vlax-true))
              )
              on
            )

            (if (and Inter (not (eq "LMAC_DINFO" (vla-get-layer Inter))))

              (mapcar
                (function
                  (lambda ( x )
                    (if (not (eq (strcase (vla-get-layer Inter)) (strcase (vla-get-name x))))
                      (vla-put-layeron x :vlax-false)
                    )
                  )
                )
                layers
              )
            )
          )

          t
        )
      )
    )
  )

  (mapcar 'entdel (list tEnt cEnt))
  (PurgeLayer "LMAC_DINFO")
  
  (princ)
)

;.................................................................................;

(princ)
(princ "\n:: DInfo.lsp | Version 1.5 | © Lee Mac 2011 www.lee-mac.com ::")
(princ "\n:: Type \"DInfo\" to Invoke ::")
(princ)

;;-------------------------------------------------------------------------------;;
;;                             End of Program Code                               ;;
;;-------------------------------------------------------------------------------;;










;;; GLOBAL ;;;
(setq break_set (ssadd))
(setq merge_vpp_points (ssadd))
(setq total_merge_vpp_list nil)
(setq temp_number 0)
(setq total_ent_list '())
(setq file_list nil)
(setq true_file_list nil)
(setq color_list nil)
(setq break_list '())
(setq ent_curve nil)
(setq sel_set_fit (ssadd))
(setq sel_set (ssadd))
;;;;; DRAWING SETING ;;;;;;;;;
  (setq
    oldEcho(getvar "CMDECHO")
    oldOsm(getvar "OSMODE")
     ;file_list (vl-directory-files "c:\\Users\\delko_000\\Desktop\\fly\\data" "*" 1)
     ;file_name_list (mapcar 'vl-filename-base file_list)
  ); end setq
  (setvar "CMDECHO" 0)
  (setvar "OSMODE" 0)
      ;;;;; BEGIN_ACTIVE_X ;;;;;;;;;
(defun begin_activex ( / )
  (vl-load-com)
  (setq acad_application (vlax-get-acad-object))
  (setq active_document (vla-get-ActiveDocument acad_application))
  (setq model_space (vla-get-ModelSpace active_document))
  (setq paper_space (vla-get-PaperSpace active_document))
);  end of begin
;;;;; HIDE ERROR FUNCTION ;;;;;;;;;
  (defun *error* (msg)
   (setvar "CMDECHO" oldEcho)
   (setvar "OSMODE" oldOsm)
  (princ)
  ); end of *error*

(defun equal_add (Count Time Impact /)
(/(* 10 (log (/ (float Time) (* Count Impact) ))) (log 10))
);; EQUAL ADD

       (defun file_line (line_number /)
       (setq opened_file_to_read (open (strcat "C:\\fly\\settings.ini") "r"))
       (setq text_list nil)
       (while (setq temp_text (read-line opened_file_to_read))
       (setq text_list (append text_list (list temp_text)))
       ); WHILE
       (close opened_file_to_read)
       (setq opened_file_to_write (open (strcat "C:\\fly\\settings.ini") "w"))
       (setq line_counter 1)
       (foreach temp_text text_list
        (if (= line_counter line_number)
        (write-line changed_line opened_file_to_write)
        ); if
        (if (/= line_counter line_number)
        (write-line temp_text opened_file_to_write)
        ); if
        (setq line_counter (+ line_counter 1))
       ); FOREACH
       (close opened_file_to_write)
       ); END FILE_LINE
(defun fill_clr (name nc /)
(setq dx (dimx_tile name) dy (dimy_tile name))
    (start_image name)
    (fill_image 0 0 dx dy nc)
(end_image)
); END FILL_CLR
(defun change_clr (name /)
(setq dx (dimx_tile name) dy (dimy_tile name))
(setq nc (acad_colordlg 80))

(if nc
   (progn
    (start_image name)
    (fill_image 0 0 dx dy nc)
    (setq changed_line (itoa nc))
    (file_line line_numb)
    (end_image)
   ); progn
 ); if
); END CHANGE_CLR
(defun c:sample (/ spSet ptLst Dr Ang sCurve oldEcho oldOsm dataLst fPt radius Ans )
;;; START DIALOG ;;;
(setq break_list '())
(setq ini_file (open (strcat "C:\\fly\\settings.ini") "r"))
;(setq ent_for_del (entlast))
(if (< (setq dcl_id (load_dialog "C:\\fly\\dample2.dcl")) 0) (exit))
(if (not (new_dialog "sample" dcl_id)) (exit))
;;;;;;;;;;;;;;; READ SETTING FROM SETTING.INI ;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; trash-line GROUP
(read-line ini_file)
     (set_tile "group_1" (read-line ini_file))
     (set_tile "group_2" (read-line ini_file))
     (set_tile "group_3" (read-line ini_file))
     (set_tile "group_4" (read-line ini_file))
     (set_tile "group_5" (read-line ini_file))

;;; trash-line ACTION
(read-line ini_file)
     (set_tile "takeoff" (read-line ini_file))
     (set_tile "put_down" (read-line ini_file))


(read-line ini_file)
(read-line ini_file)
(read-line ini_file)

;;; trash-line PARAMETERS
(read-line ini_file)
     (set_tile "day" (read-line ini_file))
     (set_tile "night" (read-line ini_file))
     (set_tile "count" (read-line ini_file))
     (set_tile "impact" (read-line ini_file))

;;; trash-line NOISE LEVEL--60
(read-line ini_file)
     (set_tile "db_60" (read-line ini_file))
     (fill_clr "clr_60" (atoi (read-line ini_file)))

     (set_tile "max_60" (read-line ini_file))
     (set_tile "equal_60" (read-line ini_file))

     (set_tile "length_60" (read-line ini_file))
     (set_tile "width_60" (read-line ini_file))
          (set_tile "scale_60" (read-line ini_file))
                    (set_tile "text_60" (read-line ini_file))

;;; trash-line NOISE LEVEL--65
(read-line ini_file)
     (set_tile "db_65" (read-line ini_file))
     (fill_clr "clr_65" (atoi (read-line ini_file)))

          (set_tile "max_65" (read-line ini_file))
     (set_tile "equal_65" (read-line ini_file))

     (set_tile "length_65" (read-line ini_file))
     (set_tile "width_65" (read-line ini_file))
               (set_tile "scale_65" (read-line ini_file))
                         (set_tile "text_65" (read-line ini_file))

;;; trash-line NOISE LEVEL--70
(read-line ini_file)
     (set_tile "db_70" (read-line ini_file))
     (fill_clr "clr_70" (atoi (read-line ini_file)))

               (set_tile "max_70" (read-line ini_file))
     (set_tile "equal_70" (read-line ini_file))



     (set_tile "length_70" (read-line ini_file))
     (set_tile "width_70" (read-line ini_file))
               (set_tile "scale_70" (read-line ini_file))
                         (set_tile "text_70" (read-line ini_file))

;;; trash-line NOISE LEVEL--75
(read-line ini_file)
     (set_tile "db_75" (read-line ini_file))
     (fill_clr "clr_75" (atoi (read-line ini_file)))

               (set_tile "max_75" (read-line ini_file))
     (set_tile "equal_75" (read-line ini_file))


     (set_tile "length_75" (read-line ini_file))
     (set_tile "width_75" (read-line ini_file))
               (set_tile "scale_75" (read-line ini_file))
                         (set_tile "text_75" (read-line ini_file))

;;; trash-line NOISE LEVEL--80
(read-line ini_file)
     (set_tile "db_80" (read-line ini_file))
     (fill_clr "clr_80" (atoi (read-line ini_file)))

               (set_tile "max_80" (read-line ini_file))
     (set_tile "equal_80" (read-line ini_file))



     (set_tile "length_80" (read-line ini_file))
     (set_tile "width_80" (read-line ini_file))
               (set_tile "scale_80" (read-line ini_file))
                         (set_tile "text_80" (read-line ini_file))

;;; trash-line NOISE LEVEL--85
(read-line ini_file)
     (set_tile "db_85" (read-line ini_file))
     (fill_clr "clr_85" (atoi (read-line ini_file)))

               (set_tile "max_85" (read-line ini_file))
     (set_tile "equal_85" (read-line ini_file))



     (set_tile "length_85" (read-line ini_file))
     (set_tile "width_85" (read-line ini_file))
               (set_tile "scale_85" (read-line ini_file))
                         (set_tile "text_85" (read-line ini_file))

;;; trash-line NOISE LEVEL--90
(read-line ini_file)
     (set_tile "db_90" (read-line ini_file))
     (fill_clr "clr_90" (atoi (read-line ini_file)))

               (set_tile "max_90" (read-line ini_file))
     (set_tile "equal_90" (read-line ini_file))



     (set_tile "length_90" (read-line ini_file))
     (set_tile "width_90" (read-line ini_file))
               (set_tile "scale_90" (read-line ini_file))
                         (set_tile "text_90" (read-line ini_file))

;;; trash-line NOISE LEVEL--95
(read-line ini_file)
     (set_tile "db_95" (read-line ini_file))
     (fill_clr "clr_95" (atoi (read-line ini_file)))

               (set_tile "max_95" (read-line ini_file))
     (set_tile "equal_95" (read-line ini_file))


     (set_tile "length_95" (read-line ini_file))
     (set_tile "width_95" (read-line ini_file))
               (set_tile "scale_95" (read-line ini_file))
                         (set_tile "text_95" (read-line ini_file))

;;; trash-line NOISE LEVEL--100
(read-line ini_file)
     (set_tile "db_100" (read-line ini_file))
     (fill_clr "clr_100" (atoi (read-line ini_file)))

               (set_tile "max_100" (read-line ini_file))
     (set_tile "equal_100" (read-line ini_file))



     (set_tile "length_100" (read-line ini_file))
     (set_tile "width_100" (read-line ini_file))
               (set_tile "scale_100" (read-line ini_file))
                         (set_tile "text_100" (read-line ini_file))

;;; trah-line CUSTOM NOISE LEVEL x_1
(read-line ini_file)
     (set_tile "db_x_1" (read-line ini_file))
     (set_tile "custom_x_1" (read-line ini_file))
     (fill_clr "clr_x_1" (atoi (read-line ini_file)))

               (set_tile "max_x_1" (read-line ini_file))
     (set_tile "equal_x_1" (read-line ini_file))


     (set_tile "length_x_1" (read-line ini_file))
     (set_tile "width_x_1" (read-line ini_file))
               (set_tile "scale_x_1" (read-line ini_file))
                         (set_tile "text_x_1" (read-line ini_file))

;;; trah-line CUSTOM NOISE LEVEL x_2
(read-line ini_file)
     (set_tile "db_x_2" (read-line ini_file))
     (set_tile "custom_x_2" (read-line ini_file))
     (fill_clr "clr_x_2" (atoi (read-line ini_file)))

               (set_tile "max_x_2" (read-line ini_file))
     (set_tile "equal_x_2" (read-line ini_file))



     (set_tile "length_x_2" (read-line ini_file))
     (set_tile "width_x_2" (read-line ini_file))
               (set_tile "scale_x_2" (read-line ini_file))
                         (set_tile "text_x_2" (read-line ini_file))

;;; trah-line CUSTOM NOISE LEVEL x_3
(read-line ini_file)
     (set_tile "db_x_3" (read-line ini_file))
     (set_tile "custom_x_3" (read-line ini_file))
     (fill_clr "clr_x_3" (atoi (read-line ini_file)))

               (set_tile "max_x_3" (read-line ini_file))
     (set_tile "equal_x_3" (read-line ini_file))


     (set_tile "length_x_3" (read-line ini_file))
     (set_tile "width_x_3" (read-line ini_file))
               (set_tile "scale_x_3" (read-line ini_file))
                         (set_tile "text_x_3" (read-line ini_file))

;;; trah-line MISC
(read-line ini_file)
     (set_tile "merge_vpp" (read-line ini_file))
     (set_tile "notify" (read-line ini_file))
                    (set_tile "auto_trim" (read-line ini_file))
          (set_tile "delete_files" (read-line ini_file))
;;;;;;;;;;;; ACTION PROCESSING ;;;;;;;;;;;;;;;;;;;;

;;; GROUP;;;
     (action_tile "group_1" "(setq changed_line \"1\")(file_line 2 )(setq changed_line \"0\")(file_line 3 )(setq changed_line \"0\")(file_line 4 )(setq changed_line \"0\")(file_line 5 )(setq changed_line \"0\")(file_line 6 )")
     (action_tile "group_2" "(setq changed_line \"1\")(file_line 3 )(setq changed_line \"0\")(file_line 2 )(setq changed_line \"0\")(file_line 4 )(setq changed_line \"0\")(file_line 5 )(setq changed_line \"0\")(file_line 6 )")
     (action_tile "group_3" "(setq changed_line \"1\")(file_line 4 )(setq changed_line \"0\")(file_line 2 )(setq changed_line \"0\")(file_line 3 )(setq changed_line \"0\")(file_line 5 )(setq changed_line \"0\")(file_line 6 )")
     (action_tile "group_4" "(setq changed_line \"1\")(file_line 5 )(setq changed_line \"0\")(file_line 2 )(setq changed_line \"0\")(file_line 3 )(setq changed_line \"0\")(file_line 4 )(setq changed_line \"0\")(file_line 6 )")
     (action_tile "group_5" "(setq changed_line \"1\")(file_line 6 )(setq changed_line \"0\")(file_line 2 )(setq changed_line \"0\")(file_line 3 )(setq changed_line \"0\")(file_line 4 )(setq changed_line \"0\")(file_line 5 )")
;;; ACTION ;;;
     (action_tile "takeoff" "(setq changed_line \"1\")(file_line 8 )(setq changed_line \"0\")(file_line 9 )")
     (action_tile "put_down" "(setq changed_line \"1\")(file_line 9 )(setq changed_line \"0\")(file_line 8 )")
;;; CALCULATE ;;;
     ; (action_tile "max" "(setq changed_line \"1\")(file_line 11 )(setq changed_line \"0\")(file_line 12 )")
     ; (action_tile "equal" "(setq changed_line \"1\")(file_line 12 )(setq changed_line \"0\")(file_line 11 )")
;;; PARAMETERS ;;;
     (action_tile "day" "(setq changed_line \"1\")(file_line 14 )(setq changed_line \"0\")(file_line 15 )")
     (action_tile "night" "(setq changed_line \"1\")(file_line 15 )(setq changed_line \"0\")(file_line 14 )")
     (action_tile "count" "(setq changed_line $value)(file_line 16 )")
     (action_tile "impact" "(setq changed_line $value)(file_line 17 )")
;;; NOISE LEVEL 60 ;;;
     (action_tile "db_60" "(setq changed_line $value)(file_line 19 )")
     (action_tile "clr_60" "(setq line_numb 20)(change_clr \"clr_60\")")

               (action_tile "max_60" "(setq changed_line $value)(file_line 21 )(setq changed_line \"0\")(file_line 22 )")
     (action_tile "equal_60" "(setq changed_line $value)(file_line 22 )(setq changed_line \"0\")(file_line 21 )")

     (action_tile "length_60" "(setq changed_line $value)(file_line 23 )")
     (action_tile "width_60" "(setq changed_line $value)(file_line 24 )")
          (action_tile "scale_60" "(setq changed_line $value)(file_line 25 )")
          (action_tile "text_60" "(setq changed_line $value)(file_line 26 )")

;;; NOISE LEVEL 65 ;;;
     (action_tile "db_65" "(setq changed_line $value)(file_line 28 )")
     (action_tile "clr_65" "(setq line_numb 29)(change_clr \"clr_65\")")

               (action_tile "max_65" "(setq changed_line $value)(file_line 30 )(setq changed_line \"0\")(file_line 31 )")
     (action_tile "equal_65" "(setq changed_line $value)(file_line 31 )(setq changed_line \"0\")(file_line 30 )")

     (action_tile "length_65" "(setq changed_line $value)(file_line 32 )")
     (action_tile "width_65" "(setq changed_line $value)(file_line 33 )")
               (action_tile "scale_65" "(setq changed_line $value)(file_line 34 )")

          (action_tile "text_65" "(setq changed_line $value)(file_line 35 )")


      ;;; NOISE LEVEL 70 ;;;
     (action_tile "db_70" "(setq changed_line $value)(file_line 37 )")
     (action_tile "clr_70" "(setq line_numb 38)(change_clr \"clr_70\")")

               (action_tile "max_70" "(setq changed_line $value)(file_line 39 )(setq changed_line \"0\")(file_line 40 )")
     (action_tile "equal_70" "(setq changed_line $value)(file_line 40 )(setq changed_line \"0\")(file_line 39 )")

     (action_tile "length_70" "(setq changed_line $value)(file_line 41 )")
     (action_tile "width_70" "(setq changed_line $value)(file_line 42 )")
               (action_tile "scale_70" "(setq changed_line $value)(file_line 43 )")

                         (action_tile "text_70" "(setq changed_line $value)(file_line 44 )")

      ;;; NOISE LEVEL 75 ;;;
     (action_tile "db_75" "(setq changed_line $value)(file_line 46 )")
     (action_tile "clr_75" "(setq line_numb 47)(change_clr \"clr_75\")")

                    (action_tile "max_75" "(setq changed_line $value)(file_line 48 )(setq changed_line \"0\")(file_line 49 )")
     (action_tile "equal_75" "(setq changed_line $value)(file_line 49 )(setq changed_line \"0\")(file_line 48 )")

     (action_tile "length_75" "(setq changed_line $value)(file_line 50 )")
     (action_tile "width_75" "(setq changed_line $value)(file_line 51 )")
               (action_tile "scale_75" "(setq changed_line $value)(file_line 52 )")
                                        (action_tile "text_75" "(setq changed_line $value)(file_line 53 )")

      ;;; NOISE LEVEL 80 ;;;
     (action_tile "db_80" "(setq changed_line $value)(file_line 55 )")
     (action_tile "clr_80" "(setq line_numb 56)(change_clr \"clr_80\")")

                    (action_tile "max_80" "(setq changed_line $value)(file_line 57 )(setq changed_line \"0\")(file_line 58 )")
     (action_tile "equal_80" "(setq changed_line $value)(file_line 58 )(setq changed_line \"0\")(file_line 57 )")


     (action_tile "length_80" "(setq changed_line $value)(file_line 59 )")
     (action_tile "width_80" "(setq changed_line $value)(file_line 60 )")
               (action_tile "scale_80" "(setq changed_line $value)(file_line 61 )")
                                        (action_tile "text_80" "(setq changed_line $value)(file_line 62 )")

            ;;; NOISE LEVEL 85 ;;;
     (action_tile "db_85" "(setq changed_line $value)(file_line 64 )")
     (action_tile "clr_85" "(setq line_numb 65)(change_clr \"clr_85\")")

                    (action_tile "max_85" "(setq changed_line $value)(file_line 66 )(setq changed_line \"0\")(file_line 67 )")
     (action_tile "equal_85" "(setq changed_line $value)(file_line 67 )(setq changed_line \"0\")(file_line 66 )")


     (action_tile "length_85" "(setq changed_line $value)(file_line 68 )")
     (action_tile "width_85" "(setq changed_line $value)(file_line 69 )")
               (action_tile "scale_85" "(setq changed_line $value)(file_line 70 )")
                                        (action_tile "text_85" "(setq changed_line $value)(file_line 71 )")


      ;;; NOISE LEVEL 90 ;;;
     (action_tile "db_90" "(setq changed_line $value)(file_line 73 )")
     (action_tile "clr_90" "(setq line_numb 74)(change_clr \"clr_90\")")

                    (action_tile "max_90" "(setq changed_line $value)(file_line 75 )(setq changed_line \"0\")(file_line 76 )")
     (action_tile "equal_90" "(setq changed_line $value)(file_line 76 )(setq changed_line \"0\")(file_line 75 )")

     (action_tile "length_90" "(setq changed_line $value)(file_line 77 )")
     (action_tile "width_90" "(setq changed_line $value)(file_line 78 )")
               (action_tile "scale_90" "(setq changed_line $value)(file_line 79 )")
                                        (action_tile "text_90" "(setq changed_line $value)(file_line 80 )")


      ;;; NOISE LEVEL 95 ;;;
     (action_tile "db_95" "(setq changed_line $value)(file_line 82 )")
     (action_tile "clr_95" "(setq line_numb 83)(change_clr \"clr_95\")")

               (action_tile "max_95" "(setq changed_line $value)(file_line 84 )(setq changed_line \"0\")(file_line 85 )")
     (action_tile "equal_95" "(setq changed_line $value)(file_line 85 )(setq changed_line \"0\")(file_line 84 )")

     (action_tile "length_95" "(setq changed_line $value)(file_line 86 )")
     (action_tile "width_95" "(setq changed_line $value)(file_line 87 )")
               (action_tile "scale_95" "(setq changed_line $value)(file_line 88 )")
                                        (action_tile "text_95" "(setq changed_line $value)(file_line 89 )")

      ;;; NOISE LEVEL 100 ;;;
     (action_tile "db_100" "(setq changed_line $value)(file_line 91 )")
     (action_tile "clr_100" "(setq line_numb 92)(change_clr \"clr_100\")")

                    (action_tile "max_100" "(setq changed_line $value)(file_line 93 )(setq changed_line \"0\")(file_line 94 )")
     (action_tile "equal_100" "(setq changed_line $value)(file_line 94 )(setq changed_line \"0\")(file_line 93 )")

     (action_tile "length_100" "(setq changed_line $value)(file_line 95 )")
     (action_tile "width_100" "(setq changed_line $value)(file_line 96 )")
               (action_tile "scale_100" "(setq changed_line $value)(file_line 97 )")
                                        (action_tile "text_100" "(setq changed_line $value)(file_line 98 )")

      ;;; NOISE LEVEL X 1 ;;;
     (action_tile "db_x_1" "(setq changed_line $value)(file_line 100 )")
     (action_tile "custom_x_1" "(setq changed_line $value)(file_line 101 )")
     (action_tile "clr_x_1" "(setq line_numb 102)(change_clr \"clr_x_1\")")

                    (action_tile "max_x_1" "(setq changed_line $value)(file_line 103 )(setq changed_line \"0\")(file_line 104 )")
     (action_tile "equal_x_1" "(setq changed_line $value)(file_line 104 )(setq changed_line \"0\")(file_line 103 )")

     (action_tile "length_x_1" "(setq changed_line $value)(file_line 105 )")
     (action_tile "width_x_1" "(setq changed_line $value)(file_line 106 )")
               (action_tile "scale_x_1" "(setq changed_line $value)(file_line 107 )")
                                        (action_tile "text_x_1" "(setq changed_line $value)(file_line 108 )")


      ;;; NOISE LEVEL X 2 ;;;
     (action_tile "db_x_2" "(setq changed_line $value)(file_line 110 )")
     (action_tile "custom_x_2" "(setq changed_line $value)(file_line 111 )")
     (action_tile "clr_x_2" "(setq line_numb 112)(change_clr \"clr_x_2\")")

                    (action_tile "max_x_2" "(setq changed_line $value)(file_line 113 )(setq changed_line \"0\")(file_line 114 )")
     (action_tile "equal_x_2" "(setq changed_line $value)(file_line 114 )(setq changed_line \"0\")(file_line 113 )")

     (action_tile "length_x_2" "(setq changed_line $value)(file_line 115 )")
     (action_tile "width_x_2" "(setq changed_line $value)(file_line 116 )")
               (action_tile "scale_x_2" "(setq changed_line $value)(file_line 117 )")
                                        (action_tile "text_x_2" "(setq changed_line $value)(file_line 118 )")


      ;;; NOISE LEVEL X 3 ;;;
     (action_tile "db_x_3" "(setq changed_line $value)(file_line 120 )")
     (action_tile "custom_x_3" "(setq changed_line $value)(file_line 121 )")
     (action_tile "clr_x_3" "(setq line_numb 122)(change_clr \"clr_x_3\")")

                    (action_tile "max_x_3" "(setq changed_line $value)(file_line 123 )(setq changed_line \"0\")(file_line 124 )")
     (action_tile "equal_x_3" "(setq changed_line $value)(file_line 124 )(setq changed_line \"0\")(file_line 123 )")

     (action_tile "length_x_3" "(setq changed_line $value)(file_line 125 )")
     (action_tile "width_x_3" "(setq changed_line $value)(file_line 126 )")
               (action_tile "scale_x_3" "(setq changed_line $value)(file_line 127 )")
                                        (action_tile "text_x_3" "(setq changed_line $value)(file_line 128 )")

      ;;; MISC ;;;
     (action_tile "merge_vpp" "(setq changed_line $value)(file_line 130 )")
          (action_tile "notify" "(setq changed_line $value)(file_line 131 )")
                    (action_tile "auto_trim" "(setq changed_line $value)(file_line 132 )")
                    (action_tile "delete_files" "(setq changed_line $value)(file_line 133 )")



     ;;; CANCEL _OK ;;;
     (action_tile "cancel" "(done_dialog)")

 (start_dialog)
 (unload_dialog dcl_id)
;;; OPEN TO DETECT ;;;
       (setq opened_file_to_read_group (open (strcat "C:\\fly\\settings.ini") "r"))

;;; DETECT GROUP ;;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (if (= (read-line opened_file_to_read_group) "1")
        (setq group_number "group_1")
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq group_number "group_2")
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq group_number "group_3")
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq group_number "group_4")
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq group_number "group_5")
        );


;;; END DETECT GROUP ;;;

;;; ACTION DETECT ;;;
        (read-line opened_file_to_read_group) ;;; trash-line

        (if (= (read-line opened_file_to_read_group) "1")
        (setq action "takeoff");; 1 means takeoff
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq action "put_down");; 2 means put down
        );

;;; END ACTION DETECT ;;;


;;; CALCULATE -- OLD ;;;
      ;   (read-line opened_file_to_read_group) ;;; trash-line


      ;   (if (= (read-line opened_file_to_read_group) "1")
      ; ;  (setq calculate 1);; 1 means max
      ;   );

      ;   (if (= (read-line opened_file_to_read_group) "1")
      ;  ; (setq calculate 2);; 2 means equal
      ;   );


(read-line opened_file_to_read_group)
(read-line opened_file_to_read_group)
(read-line opened_file_to_read_group)

;;; END CALCULATE ;;;


;;; PARAMETERS ;;;
        (read-line opened_file_to_read_group) ;;; trash-line


        (if (= (read-line opened_file_to_read_group) "1")
        (setq time 16);; 16 means day
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq time 8);; 2 means night
        );

        (setq count_air (atoi (read-line opened_file_to_read_group)))
        (setq time_impact (atoi (read-line opened_file_to_read_group)))

                (if (or (<= count_air 0) (<= time_impact 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END PARAMETERS ;;;

;;; NOISE 60 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_60 (atoi (read-line opened_file_to_read_group)))
        (setq clr_60 (atoi (read-line opened_file_to_read_group)))

                (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_60 1)
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_60 2)
        );


        (setq length_60 (atoi (read-line opened_file_to_read_group)))
        (setq width_60 (atoi (read-line opened_file_to_read_group)))
                (setq scale_60 (atoi (read-line opened_file_to_read_group)))
                                (setq text_60 (read-line opened_file_to_read_group))

                        (if (or (<= length_60 0) (<= width_60 0) (<= scale_60 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE 60 ;;;

;;; NOISE 65 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_65 (atoi (read-line opened_file_to_read_group)))
        (setq clr_65 (atoi (read-line opened_file_to_read_group)))


                (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_65 1)
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_65 2)
        );



        (setq length_65 (atoi (read-line opened_file_to_read_group)))
        (setq width_65 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_65 (atoi (read-line opened_file_to_read_group)))
                                (setq text_65 (read-line opened_file_to_read_group))
                                                (if (or (<= length_65 0) (<= width_65 0) (<= scale_65 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE 65 ;;;

;;; NOISE 70 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_70 (atoi (read-line opened_file_to_read_group)))
        (setq clr_70 (atoi (read-line opened_file_to_read_group)))


                (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_70 1)
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_70 2)
        );


        (setq length_70 (atoi (read-line opened_file_to_read_group)))
        (setq width_70 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_70 (atoi (read-line opened_file_to_read_group)))
                                (setq text_70 (read-line opened_file_to_read_group))
                                                (if (or (<= length_70 0) (<= width_70 0) (<= scale_70 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE 70 ;;;

;;; NOISE 75 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_75 (atoi (read-line opened_file_to_read_group)))
        (setq clr_75 (atoi (read-line opened_file_to_read_group)))


                (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_75 1)
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_75 2)
        );


        (setq length_75 (atoi (read-line opened_file_to_read_group)))
        (setq width_75 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_75 (atoi (read-line opened_file_to_read_group)))
                                (setq text_75 (read-line opened_file_to_read_group))
                                                (if (or (<= length_75 0) (<= width_75 0) (<= scale_75 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE 75 ;;;

;;; NOISE 80 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_80 (atoi (read-line opened_file_to_read_group)))
        (setq clr_80 (atoi (read-line opened_file_to_read_group)))


                (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_80 1)
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_80 2)
        );

        (setq length_80 (atoi (read-line opened_file_to_read_group)))
        (setq width_80 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_80 (atoi (read-line opened_file_to_read_group)))
                                (setq text_80 (read-line opened_file_to_read_group))
                                                (if (or (<= length_80 0) (<= width_80 0) (<= scale_80 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE 80 ;;;

;;; NOISE 85 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_85 (atoi (read-line opened_file_to_read_group)))
        (setq clr_85 (atoi (read-line opened_file_to_read_group)))


                (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_85 1)
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_85 2)
        );


        (setq length_85 (atoi (read-line opened_file_to_read_group)))
        (setq width_85 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_85 (atoi (read-line opened_file_to_read_group)))
                                (setq text_85 (read-line opened_file_to_read_group))
                                                (if (or (<= length_85 0) (<= width_85 0) (<= scale_85 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE 85 ;;;

;;; NOISE 90 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_90 (atoi (read-line opened_file_to_read_group)))
        (setq clr_90 (atoi (read-line opened_file_to_read_group)))


                (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_90 1)
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_90 2)
        );


        (setq length_90 (atoi (read-line opened_file_to_read_group)))
        (setq width_90 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_90 (atoi (read-line opened_file_to_read_group)))
                                (setq text_90 (read-line opened_file_to_read_group))
                                                (if (or (<= length_90 0) (<= width_90 0) (<= scale_90 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE 90 ;;;

;;; NOISE 95 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_95 (atoi (read-line opened_file_to_read_group)))
        (setq clr_95 (atoi (read-line opened_file_to_read_group)))


                (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_95 1)
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_95 2)
        );


        (setq length_95 (atoi (read-line opened_file_to_read_group)))
        (setq width_95 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_95 (atoi (read-line opened_file_to_read_group)))
                                (setq text_95 (read-line opened_file_to_read_group))
                                                (if (or (<= length_95 0) (<= width_95 0) (<= scale_95 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE 95 ;;;

;;; NOISE 100 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_100 (atoi (read-line opened_file_to_read_group)))
        (setq clr_100 (atoi (read-line opened_file_to_read_group)))


                (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_100 1)
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_100 2)
        );


        (setq length_100 (atoi (read-line opened_file_to_read_group)))
        (setq width_100 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_100 (atoi (read-line opened_file_to_read_group)))
                                (setq text_100 (read-line opened_file_to_read_group))
                                                (if (or (<= length_100 0) (<= width_100 0) (<= scale_100 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE 100 ;;;

;;; NOISE X 1;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_x_1 (atoi (read-line opened_file_to_read_group)))
        (setq custom_x_1 (atoi (read-line opened_file_to_read_group)))
        (setq clr_x_1 (atoi (read-line opened_file_to_read_group)))


                (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_x_1 1)
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_x_1 2)
        );


        (setq length_x_1 (atoi (read-line opened_file_to_read_group)))
        (setq width_x_1 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_x_1 (atoi (read-line opened_file_to_read_group)))
                                (setq text_x_1 (read-line opened_file_to_read_group))
                                                (if (or (<= length_x_1 0) (<= width_x_1 0) (<= scale_x_1 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE X 1 ;;;

;;; NOISE X 2 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_x_2 (atoi (read-line opened_file_to_read_group)))
        (setq custom_x_2 (atoi (read-line opened_file_to_read_group)))
        (setq clr_x_2 (atoi (read-line opened_file_to_read_group)))


                (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_x_2 1)
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_x_2 2)
        );


        (setq length_x_2 (atoi (read-line opened_file_to_read_group)))
        (setq width_x_2 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_x_2 (atoi (read-line opened_file_to_read_group)))
                                (setq text_x_2 (read-line opened_file_to_read_group))
                                                (if (or (<= length_x_2 0) (<= width_x_2 0) (<= scale_x_2 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE X 2 ;;;

;;; NOISE X 3 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_x_3 (atoi (read-line opened_file_to_read_group)))
        (setq custom_x_3 (atoi (read-line opened_file_to_read_group)))
        (setq clr_x_3 (atoi (read-line opened_file_to_read_group)))


                (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_x_3 1)
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_x_3 2)
        );


        (setq length_x_3 (atoi (read-line opened_file_to_read_group)))
        (setq width_x_3 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_x_3 (atoi (read-line opened_file_to_read_group)))
                                (setq text_x_3 (read-line opened_file_to_read_group))
                                                (if (or (<= length_x_3 0) (<= width_x_3 0) (<= scale_x_3 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE X 3 ;;;

;;; MISC ;;;

        (read-line opened_file_to_read_group) ;;; trash-line
        (setq merge_vpp (atoi (read-line opened_file_to_read_group)))
                (setq notify (atoi (read-line opened_file_to_read_group)))
                                                          (setq auto_trim (atoi (read-line opened_file_to_read_group)))
      
                                (setq delete_files (atoi (read-line opened_file_to_read_group)))

;;; END MISC ;;;
;;; FORMAT RAW SETTINGS ;;;

;;; MAKE NEW FILE LIST ;;;


(setq equ_level (fix (round (equal_add count_air (* time 3600) time_impact) 0)))













;;;; DETECT CUSTOM X 1 ;;;
(if (= db_x_1 1)
  (progn
    (if (= calculate_x_1 2)
      (progn
        (setq custom_x_1 (fix (round (+ custom_x_1 equ_level) 0)))
      )
    )
    (if (not (member custom_x_1 file_list))
        (progn
          (make_list custom_x_1)
        ); progn not in list 60 65 70..
    ); if not in list 60 65 70..
  ); progn check box OK
); if check box OK


       ;;;; DETECT CUSTOM X 2 ;;;
(if (= db_x_2 1)
  (progn
    (if (= calculate_x_2 2)
      (progn
        (setq custom_x_2 (fix (round (+ custom_x_2 equ_level) 0)))
      )
    )
    (if (not (member custom_x_2 file_list))
        (progn
            (make_list custom_x_2)

        ); progn not in list 60 65 70..
    ); if not in list 60 65 70..
  ); progn check box OK
); if check box OK



       ;;;; DETECT CUSTOM X 3 ;;;
(if (= db_x_3 1)
  (progn
    (if (= calculate_x_3 2)
      (progn
        (setq custom_x_3 (fix (round (+ custom_x_3 equ_level) 0)))
      )
    )
    (if (not (member custom_x_3 file_list))
        (progn
          (make_list custom_x_3)
        ); progn 
    ); if 
  ); progn check box OK
); if check box OK

;;;;; END MAKE NEW FILE LIST ;;;;;

(setq true_file_list nil)
(setq color_list nil)
(setq scale_list nil)
(setq length_list nil)
(setq width_list nil)
(setq symbol_list nil)

(if (= db_60 1)
    (progn

        (setq color_list (append color_list (list clr_60)))
        (setq scale_list (append scale_list (list scale_60)))
        (setq length_list (append length_list (list length_60)))
        (setq width_list (append width_list (list width_60)))
        (setq symbol_list (append symbol_list (list text_60)))

        (if (= calculate_60 1)
           (progn
           (setq true_file_list (append true_file_list (list "60dB")))
           ); progn
        ); if

         (if (= calculate_60 2)
           (progn
             (make_list (+ 60  equ_level))
             (setq true_file_list (append true_file_list (list (strcat (itoa (+ 60  equ_level)) "dB"))))
            ); progn
          ); if

    ); progn
); if



(if (= db_65 1)
    (progn

        (setq color_list (append color_list (list clr_65)))
        (setq scale_list (append scale_list (list scale_65)))
        (setq length_list (append length_list (list length_65)))
        (setq width_list (append width_list (list width_65)))
        (setq symbol_list (append symbol_list (list text_65)))

        (if (= calculate_65 1)
           (progn
           (setq true_file_list (append true_file_list (list "65dB")))
           ); progn
        ); if

         (if (= calculate_65 2)
           (progn
             (make_list (+ 65  equ_level))
             (setq true_file_list (append true_file_list (list (strcat (itoa (+ 65  equ_level)) "dB"))))
            ); progn
          ); if


    )
)




(if (= db_70 1)
    (progn

        (setq color_list (append color_list (list clr_70)))
        (setq scale_list (append scale_list (list scale_70)))
        (setq length_list (append length_list (list length_70)))
        (setq width_list (append width_list (list width_70)))
        (setq symbol_list (append symbol_list (list text_70)))
                (if (= calculate_70 1)
           (progn
           (setq true_file_list (append true_file_list (list "70dB")))
           ); progn
        ); if

         (if (= calculate_70 2)
           (progn
             (make_list (+ 70  equ_level))
             (setq true_file_list (append true_file_list (list (strcat (itoa (+ 70  equ_level)) "dB"))))
            ); progn
          ); if


    )
)

(if (= db_75 1)
    (progn

        (setq color_list (append color_list (list clr_75)))
        (setq scale_list (append scale_list (list scale_75)))
                (setq length_list (append length_list (list length_75)))
        (setq width_list (append width_list (list width_75)))
        (setq symbol_list (append symbol_list (list text_75)))
                (if (= calculate_75 1)
           (progn
           (setq true_file_list (append true_file_list (list "75dB")))
           ); progn
        ); if

         (if (= calculate_75 2)
           (progn
             (make_list (+ 75  equ_level))
             (setq true_file_list (append true_file_list (list (strcat (itoa (+ 75  equ_level)) "dB"))))
            ); progn
          ); if


    )
)

(if (= db_80 1)
    (progn

        (setq color_list (append color_list (list clr_80)))
        (setq scale_list (append scale_list (list scale_80)))
                (setq length_list (append length_list (list length_80)))
        (setq width_list (append width_list (list width_80)))
        (setq symbol_list (append symbol_list (list text_80)))
                (if (= calculate_80 1)
           (progn
           (setq true_file_list (append true_file_list (list "80dB")))
           ); progn
        ); if

         (if (= calculate_80 2)
           (progn
             (make_list (+ 80  equ_level))
             (setq true_file_list (append true_file_list (list (strcat (itoa (+ 80  equ_level)) "dB"))))
            ); progn
          ); if


    )
)


(if (= db_85 1)
    (progn

(setq color_list (append color_list (list clr_85)))
        (setq scale_list (append scale_list (list scale_85)))
                (setq length_list (append length_list (list length_85)))
        (setq width_list (append width_list (list width_85)))
        (setq symbol_list (append symbol_list (list text_85)))
                (if (= calculate_85 1)
           (progn
           (setq true_file_list (append true_file_list (list "85dB")))
           ); progn
        ); if

         (if (= calculate_85 2)
           (progn
             (make_list (+ 85  equ_level))
             (setq true_file_list (append true_file_list (list (strcat (itoa (+ 85  equ_level)) "dB"))))
            ); progn
          ); if


)
    )

(if (= db_90 1)
    (progn

    (setq color_list (append color_list (list clr_90)))
        (setq scale_list (append scale_list (list scale_90)))
                (setq length_list (append length_list (list length_90)))
        (setq width_list (append width_list (list width_90)))
        (setq symbol_list (append symbol_list (list text_90)))

                (if (= calculate_90 1)
           (progn
           (setq true_file_list (append true_file_list (list "90dB")))
           ); progn
        ); if

         (if (= calculate_90 2)
           (progn
             (make_list (+ 90  equ_level))
             (setq true_file_list (append true_file_list (list (strcat (itoa (+ 90  equ_level)) "dB"))))
            ); progn
          ); if

)
    )

(if (= db_95 1)
    (progn

(setq color_list (append color_list (list clr_95)))
        (setq scale_list (append scale_list (list scale_95)))
                (setq length_list (append length_list (list length_95)))
        (setq width_list (append width_list (list width_95)))
        (setq symbol_list (append symbol_list (list text_95)))

                (if (= calculate_95 1)
           (progn
           (setq true_file_list (append true_file_list (list "95dB")))
           ); progn
        ); if

         (if (= calculate_95 2)
           (progn
             (make_list (+ 95  equ_level))
             (setq true_file_list (append true_file_list (list (strcat (itoa (+ 95  equ_level)) "dB"))))
            ); progn
          ); if


)
    )

(if (= db_100 1)
    (progn

(setq color_list (append color_list (list clr_100)))
        (setq scale_list (append scale_list (list scale_100)))
                (setq length_list (append length_list (list length_100)))
        (setq width_list (append width_list (list width_100)))
        (setq symbol_list (append symbol_list (list text_100)))
                (if (= calculate_100 1)
           (progn
           (setq true_file_list (append true_file_list (list "100dB")))
           ); progn
        ); if

         (if (= calculate_100 2)
           (progn
             (make_list (+ 100  equ_level))
             (setq true_file_list (append true_file_list (list (strcat (itoa (+ 100  equ_level)) "dB"))))
            ); progn
          ); if


)
)



(if (= db_x_1 1)
(progn

(setq color_list (append color_list (list clr_x_1)))
        (setq scale_list (append scale_list (list scale_x_1)))
                (setq length_list (append length_list (list length_x_1)))
        (setq width_list (append width_list (list width_x_1)))
        (setq symbol_list (append symbol_list (list text_x_1)))


                  (setq true_file_list (append true_file_list (list (strcat (itoa custom_x_1) "dB"))))


)
)

(if (= db_x_2 1)
(progn

(setq color_list (append color_list (list clr_x_2)))
        (setq scale_list (append scale_list (list scale_x_2)))
                (setq length_list (append length_list (list length_x_2)))
        (setq width_list (append width_list (list width_x_2)))
        (setq symbol_list (append symbol_list (list text_x_2)))
                          (setq true_file_list (append true_file_list (list (strcat (itoa custom_x_2) "dB"))))
)
)

(if (= db_x_3 1)
(progn

(setq color_list (append color_list (list clr_x_3)))
        (setq scale_list (append scale_list (list scale_x_3)))
                (setq length_list (append length_list (list length_x_3)))
        (setq width_list (append width_list (list width_x_3)))
        (setq symbol_list (append symbol_list (list text_x_3)))
                  (setq true_file_list (append true_file_list (list (strcat (itoa custom_x_3) "dB"))))

)
)



; (setq split_number 5)
; (setq temp_level_0 0)

; (repeat split_number

; (setq temp_level_0 (+ 1 temp_level_0))
; (setq temp_number_level_0 (+ 60 temp_level_0))
; (make_list temp_number_level_0)
; (setq symbol (rtos temp_number_level_0))
; (setq color_list (append color_list (list 80)))
;         (setq scale_list (append scale_list (list 50)))
;         (setq length_list (append length_list (list 100)))
;         (setq width_list (append width_list (list 100)))
;         (setq symbol_list (append symbol_list (list symbol)))
;         (setq true_file_list (append true_file_list (list (strcat (itoa temp_number_level_0) "dB"))))
; );  repeat



(setq split_number 5)
(setq temp_level 0)

(repeat split_number
(setq temp_level (+ 1 temp_level))
(setq temp_number_level (+ 60 temp_level))
(make_list temp_number_level)


(setq symbol (rtos temp_number_level))

(setq color_list (append color_list (list 10)))
        (setq scale_list (append scale_list (list 50)))
                (setq length_list (append length_list (list 100)))
        (setq width_list (append width_list (list 100)))
        (setq symbol_list (append symbol_list (list symbol)))
                  (setq true_file_list (append true_file_list (list (strcat (itoa temp_number_level) "dB"))))


);  repeat



(setq split_number 5)
(setq temp_level 0)

(repeat split_number
(setq temp_level (+ 1 temp_level))
(setq temp_number_level (+ 65 temp_level))
(make_list temp_number_level)


(setq symbol (rtos temp_number_level))

(setq color_list (append color_list (list 50)))
        (setq scale_list (append scale_list (list 50)))
                (setq length_list (append length_list (list 100)))
        (setq width_list (append width_list (list 100)))
        (setq symbol_list (append symbol_list (list symbol)))
                  (setq true_file_list (append true_file_list (list (strcat (itoa temp_number_level) "dB"))))


);  repeat



(setq split_number 5)
(setq temp_level 0)

(repeat split_number
(setq temp_level (+ 1 temp_level))
(setq temp_number_level (+ 70 temp_level))
(make_list temp_number_level)


(setq symbol (rtos temp_number_level))

(setq color_list (append color_list (list 50)))
        (setq scale_list (append scale_list (list 50)))
                (setq length_list (append length_list (list 100)))
        (setq width_list (append width_list (list 100)))
        (setq symbol_list (append symbol_list (list symbol)))
                  (setq true_file_list (append true_file_list (list (strcat (itoa temp_number_level) "dB"))))


);  repeat


(setq split_number 5)
(setq temp_level 0)

(repeat split_number
(setq temp_level (+ 1 temp_level))
(setq temp_number_level (+ 75 temp_level))
(make_list temp_number_level)


(setq symbol (rtos temp_number_level))

(setq color_list (append color_list (list 50)))
        (setq scale_list (append scale_list (list 50)))
                (setq length_list (append length_list (list 100)))
        (setq width_list (append width_list (list 100)))
        (setq symbol_list (append symbol_list (list symbol)))
                  (setq true_file_list (append true_file_list (list (strcat (itoa temp_number_level) "dB"))))


);  repeat


(setq split_number 5)
(setq temp_level 0)

(repeat split_number
(setq temp_level (+ 1 temp_level))
(setq temp_number_level (+ 80 temp_level))
(make_list temp_number_level)


(setq symbol (rtos temp_number_level))

(setq color_list (append color_list (list 50)))
        (setq scale_list (append scale_list (list 50)))
                (setq length_list (append length_list (list 100)))
        (setq width_list (append width_list (list 100)))
        (setq symbol_list (append symbol_list (list symbol)))
                  (setq true_file_list (append true_file_list (list (strcat (itoa temp_number_level) "dB"))))


);  repeat


(setq split_number 5)
(setq temp_level 0)

(repeat split_number
(setq temp_level (+ 1 temp_level))
(setq temp_number_level (+ 85 temp_level))
(make_list temp_number_level)


(setq symbol (rtos temp_number_level))

(setq color_list (append color_list (list 50)))
        (setq scale_list (append scale_list (list 50)))
                (setq length_list (append length_list (list 100)))
        (setq width_list (append width_list (list 100)))
        (setq symbol_list (append symbol_list (list symbol)))
                  (setq true_file_list (append true_file_list (list (strcat (itoa temp_number_level) "dB"))))


);  repeat

(setq split_number 5)
(setq temp_level 0)

(repeat split_number
(setq temp_level (+ 1 temp_level))
(setq temp_number_level (+ 90 temp_level))
(make_list temp_number_level)


(setq symbol (rtos temp_number_level))

(setq color_list (append color_list (list 50)))
        (setq scale_list (append scale_list (list 50)))
                (setq length_list (append length_list (list 100)))
        (setq width_list (append width_list (list 100)))
        (setq symbol_list (append symbol_list (list symbol)))
                  (setq true_file_list (append true_file_list (list (strcat (itoa temp_number_level) "dB"))))


);  repeat


(setq split_number 5)
(setq temp_level 0)

(repeat split_number
(setq temp_level (+ 1 temp_level))
(setq temp_number_level (+ 95 temp_level))
(make_list temp_number_level)


(setq symbol (rtos temp_number_level))

(setq color_list (append color_list (list 50)))
        (setq scale_list (append scale_list (list 50)))
                (setq length_list (append length_list (list 100)))
        (setq width_list (append width_list (list 100)))
        (setq symbol_list (append symbol_list (list symbol)))
                  (setq true_file_list (append true_file_list (list (strcat (itoa temp_number_level) "dB"))))


);  repeat









(princ "\n<<< Select spline >>>")
  (if (setq spSet (ssget  '((0 . "SPLINE"))))    
    (progn
;;;;; MERGE VPP ? ;;;;
      (if (= merge_vpp 1)
        (progn
(princ "\n<<< Select spline for merge >>>")
          (if (setq merge_set (ssget  '((0 . "SPLINE"))))
          (progn   
            )
          )
          )
        )
;;; END MERGE VPP ;;;     
;;;;;;;;; FILE CYCLE ::::::::::::::::
    (foreach temp_name true_file_list

      (setq
        total_sel (ssadd) 
        count_spline (sslength spSet)
        temp_number 0
        merge_vpp_points (ssadd)
      ); end setq  
;;;;;;;;; SPLINE CYCLE ;;;;;;;;;;;;;;;;;
      (setq break_set (ssadd))
        (setq break_list '())
      (repeat count_spline
      (setq 
        sCurve(vlax-ename->vla-object(ssname spSet temp_number))
        dataLst '()
        end_point nil
        start_point nil
        temp_number (+ temp_number 1)
      ); end setq

      (setq
        width_coeff (/ (float (car width_list)) 100) 
        length_coeff  (/ (float (car length_list)) 100)
        radius_length '()
        counter_test 1
        step (* 1000 length_coeff)
        temp_length 0
        point_list (list )
        spline_length (vlax-curve-getDistAtPoint sCurve (vlax-curve-getEndPoint sCurve))
        true_count (+ (/ spline_length step) 1)
        ok_point 1
      ); end setq
;;;;;;;;;;;;;; READ FILE DATA ;;;;;;;;;;;;;;;;
      (setq
        ff (open (strcat "C:\\fly\\data\\" group_number "\\" action "\\" temp_name ".txt") "r")
        ;trash_line (read-line ff)
      ); end setq

   



      (while (and (> ok_point 0) (<= counter_test true_count))
        (setq probe_line (read-line ff))

        (if (= probe_line ())
          (setq ok_point 0)
        )

        (if (/= probe_line ())
          (progn
            (setq temp_radius (* (float (atoi probe_line)) width_coeff))
            (setq counter_test (+ counter_test 1))

            (setq point_list (append point_list (list  (vlax-curve-getPointAtDist sCurve temp_length)))) 
                        (setq temp_length (+ temp_length step))
            (setq radius_length (append radius_length (list temp_radius)))
          ); end progn
        ); end if
      ); end while

      (foreach pt point_list

        (setq Dr (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve pt)))
        (setq
          Ang (- pi(atan(/(car Dr)(cadr Dr))))
          dataLst (append dataLst (list(list(trans pt 0 1) Ang))); 
        ); setq
      ); end foreach 

      (setq counter 0)  
      (while dataLst
        (setq 
          fPt (caar dataLst)
          Ang (cadar dataLst)
          radius (car radius_length)
        ); end setq
 ;;;;;;;;;; MAKE TRELISTICK (counter = 0) ;;;;;;;;;;;
        (if (= counter 0)  
          (progn
            (setq double_der (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve fPt)));
            (setq base_anglee_point fPt)
            

            (if (> (cadr double_der) 0)
              (progn
                (command "_.line" fPt 
                (trans(polar fPt  (+ Ang 0.78)  radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq start_angle_point (list (vlax-curve-getEndPoint temp_line)))
                (vla-Delete temp_line)

                (command "_.line" fPt 
                (trans(polar fPt   (+ Ang 1.56)   radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq med_angle_point (list (vlax-curve-getEndPoint temp_line)))
                (vla-Delete temp_line)

                (command "_.line" fPt 
                (trans(polar fPt  (+ Ang 2.34)  radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq end_angle_point (list (vlax-curve-getEndPoint temp_line)))
                (vla-Delete temp_line)
              ); progn   
            ); if

            (if (<= (cadr double_der) 0)
              (progn
                (command "_.line" fPt 
                (trans(polar fPt  (- Ang 2.34)  radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq start_angle_point (list (vlax-curve-getEndPoint temp_line)))
                (vla-Delete temp_line)

                (command "_.line" fPt 
                (trans(polar fPt   (- Ang 1.56)   radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq med_angle_point (list (vlax-curve-getEndPoint temp_line)))
                (vla-Delete temp_line)

                (command "_.line" fPt 
                (trans(polar fPt  (- Ang 0.78)  radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq end_angle_point (list (vlax-curve-getEndPoint temp_line)))
                (vla-Delete temp_line)
              ); progn
            ) ; if
          ); progn
        ); if
;;;;;;;;;; SPLIT SPLINE ;;;;;;;;;;;;;;
          (if radius
            (progn
              (if (< (cadr (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve fPt))) 0)
                (progn
                  (command "_.pline"  (trans(polar fPt Ang radius)0 1) (trans(polar fPt (- Ang Pi) radius)0 1) "")
                  (setq temp_line (vlax-ename->vla-object (entlast)))
                  (setq end_point (append end_point (list (vlax-curve-getEndPoint temp_line))))  
                  (setq start_point (append start_point (list (vlax-curve-getStartPoint temp_line))))
                  (entdel (entlast))
                )
              ); end if

              (if (>= (cadr (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve fPt))) 0)
                (progn
                  (command "_.pline"  (trans(polar fPt Ang radius)0 1) (trans(polar fPt (- Ang Pi) radius) 0 1) "")
                  (setq temp_line (vlax-ename->vla-object (entlast)))
                  (setq end_point (append end_point (list (vlax-curve-getStartPoint temp_line))))  
                  (setq start_point (append start_point (list (vlax-curve-getEndPoint temp_line))))
                  (entdel (entlast))
                ); progn
              ); end if
            ); progn
          ); if

          (setq 
            dataLst (cdr dataLst)
            radius_length (cdr radius_length)
          ); setq



;;;;; BREAK at the END of the curve FOR #2 ;;;;;;;
(if (and (= (length dataLst) 1) (> ok_point 0))
  (progn
         (command "_.pline"  (trans(polar fPt Ang (* radius 1.1)) 0 1) (trans(polar fPt (- Ang Pi) (* radius 1.1)) 0 1) "")
         (ssadd (entlast) break_set) 
         (setq break_list (append break_list (list (entlast))))
         (if (= notify 1)
         (alert "SHORT SPLINE! DONT FORGET TRIM IT!");;; NOTIFY !!!!!
         ); if
         ;(setq total_ent_list (append total_ent_list (list (entlast))))

  )
);


          (if (not dataLst)
            (princ)
          ); if
          (setq counter (+ counter 1))


        ); end while datalist



       (if (= ok_point 1)
          (setq point_list_for_sort point_list)
          (setq point_list (append point_list (list (vlax-curve-getEndPoint sCurve))))
           
       ); if

        (close ff)

        (setq ff nil)
        (setq temp_spline nil)
        (setq intersect_probe nil)
        (setq intersect_probe_again nil)
        (setq intersect_probe_again_2 nil)
;; TRELISTNIK zasovavaem k rectanglam ;;;;
(setq base_start_angle (list (car start_point)))
(setq base_end_angle (list (car end_point)))

  (setq temp_angle_spline  (append base_start_angle  end_angle_point med_angle_point start_angle_point base_end_angle base_start_angle))

  (command "._PLINE")
  (apply 'command temp_angle_spline);
  (command "")
  
  (ssadd (entlast) total_sel)
;;;;;;;;;;; END TRELISTNIK ;;;;;;;;;;;;;;;;
;;;;;;;;; CREATE RECTANGLE'S POINT FOR MERGE VPP ;;;;;;;;;;;;;;;;
(if (= merge_vpp 1) 
  (progn
     (if (ssmemb (ssname spSet (- temp_number 1)) merge_set)
        (progn
        (command "_.point" (car end_point))
        (ssadd (entlast) merge_vpp_points)
        (setq total_merge_vpp_list (append total_merge_vpp_list (list (entlast))))

        (command "_.point" (car start_point))
        (ssadd (entlast) merge_vpp_points)
        (setq total_merge_vpp_list (append total_merge_vpp_list (list (entlast))))

        ); progn
    ); if
  ); progn
); if
;;; DRAW RECTANGLES ;;;
        (repeat  (- (length start_point) 1) 
        (setq temp_spline (append (list (car start_point) (cadr start_point) (cadr end_point) (car end_point) (car start_point))))

  (command "._PLINE")
  (apply 'command temp_spline);
  (command "")
  ;(alert "first done")
        (setq temp_spline_vla (vlax-ename->vla-object (entlast)))
        (setq intersect_probe (vlax-invoke temp_spline_vla 'IntersectWith temp_spline_vla acextendnone))

        (if (> (length intersect_probe) 12)

               (progn
               (entdel (entlast))
               (setq temp_spline_shit (append (list (car start_point) (cadr start_point) (car end_point) (cadr end_point)  (car start_point))))
               (command "._PLINE")
               (apply 'command temp_spline_shit);
               (command "" )
               )
        )
        (setq temp_spline_shit (vlax-ename->vla-object (entlast)))
        (setq intersect_probe_again (vlax-invoke temp_spline_shit 'IntersectWith temp_spline_shit acExtendNone))

         (if (> (length intersect_probe_again) 12)
               (progn
               (entdel (entlast));
               (setq temp_spline_shit_again (append (list (car start_point) (car end_point) (cadr end_point) (cadr start_point)  (car start_point))))
               (command "._PLINE")
               (apply 'command temp_spline_shit_again);
               (command ""  )
         )
         )
        
        (setq temp_spline_shit_2 (vlax-ename->vla-object (entlast)))
        (setq intersect_probe_again_2 (vlax-invoke temp_spline_shit_2 'IntersectWith temp_spline_shit_2 acExtendNone))

         (if (> (length intersect_probe_again_2) 12)
               (progn
               (entdel (entlast));
               (setq temp_spline_shit_again_2 (append (list (car start_point) (cadr end_point) (car end_point) (cadr start_point)  (car start_point))))
               (command "._PLINE")
               (apply 'command temp_spline_shit_again);
               (command ""  )
         )
         )

        (ssadd (entlast) total_sel)
        (setq start_point (cdr start_point))
        (setq end_point (cdr end_point))

        ); repeat
;; END DRAW RECTANGLES ;;;
      ); END SPLINE CYCLE!!!
(setq break_back break_list)

;;;;;;;;;;;;; MERGE VPP ;;;;;;;
(defun LM:ConvexHull ( lst / ch p0 )
    (cond
        (   (< (length lst) 4) lst)
        (   (setq p0 (car lst))
            (foreach p1 (cdr lst)
                (if (or (< (cadr p1) (cadr p0))
                        (and (equal (cadr p1) (cadr p0) 1e-8) (< (car p1) (car p0)))
                    )
                    (setq p0 p1)
                )
            )
            (setq lst
                (vl-sort lst
                    (function
                        (lambda ( a b / c d )
                            (if (equal (setq c (angle p0 a)) (setq d (angle p0 b)) 1e-8)
                                (< (distance p0 a) (distance p0 b))
                                (< c d)
                            )
                        )
                    )
                )
            )
            (setq ch (list (caddr lst) (cadr lst) (car lst)))
            (foreach pt (cdddr lst)
                (setq ch (cons pt ch))
                (while (and (caddr ch) (LM:Clockwise-p (caddr ch) (cadr ch) pt))
                    (setq ch (cons pt (cddr ch)))
                )
            )
            ch
        )
    )
)

;; Clockwise-p  -  Lee Mac
;; Returns T if p1,p2,p3 are clockwise oriented or collinear
                 
(defun LM:Clockwise-p ( p1 p2 p3 )
    (<  (-  (* (- (car  p2) (car  p1)) (- (cadr p3) (cadr p1)))
            (* (- (cadr p2) (cadr p1)) (- (car  p3) (car  p1)))
        )
        1e-8
    )
)


            (repeat (setq i (sslength merge_vpp_points))
                (setq l (cons (cdr (assoc 10 (entget (ssname merge_vpp_points (setq i (1- i)))))) l))
            )
            (setq l (LM:ConvexHull l))
            (entmakex
                (append
                    (list
                       '(000 . "LWPOLYLINE")
                       '(100 . "AcDbEntity")
                       '(100 . "AcDbPolyline")
                        (cons 90 (length l))
                       '(070 . 1)
                    )
                    (mapcar '(lambda ( x ) (cons 10 x)) l)
                )
            )

        (ssadd (entlast) total_sel)
      ;  (setq merge_vpp_points (ssadd))
(setq l nil)


;;;;;;;;; UNION AREAS ;;;;;;;;;;;;
(setq 
  areas nil
  ss nil
  el nil
)



(defun c:mp( / )
  
  (defun getfromlast(e / s)
    (setq
     s (ssadd)
    )
      (while (setq e (entnext e))
        (setq
          s (ssadd e s)
        )
      )
  ); GETFROMLAST
  (setq ss total_sel)
  (setq el (entlast))
  
  (command "_.region" ss "")  
  (command "_.union" (getfromlast el) "")

  (setq el (entlast))
  (command "_.explode" (entlast) )  
  (setq el_2 (entlast))

  (setq areas (getfromlast el))
  (setq explode_counter 0)



;;;; add to total_ent
(if (= (cdr (cadr (entget (ssname areas 1)))) "REGION")
  (progn

        (setq trim_proba 0)
    (setq total_fit (ssadd))

    (repeat (sslength areas)
    (setq el (entlast))
    (command "_.explode" (ssname areas explode_counter))

        (command "_.pedit" "_m" (getfromlast el) "" "_Y" "_J" "" "")
;(alert "AAA")
    (setq ent_curve (entlast))


(if (= auto_trim 1)
  (progn

(if (= trim_proba 0)
  (progn


 (setq vla_curve (vlax-ename->vla-object ent_curve))
 (setq  pt3_list '())

 (setq true_break_list '())
 (setq sel_set_fit (ssadd))
 (setq sel_set (ssadd))
 ;;;; FIND CURVE AND POINTS ;;;;;;;
 (while (> (length break_list) 0)
   ;(alert "next pt3")
 (setq temp_line (vlax-ename->vla-object (car break_list)))
 (setq intersect_probe (vlax-invoke vla_curve 'IntersectWith temp_line acextendnone))

 (if (= (length intersect_probe) 6)
(progn
(setq pt1 (list (nth 0 intersect_probe) (nth 1 intersect_probe) (nth 2 intersect_probe)))
(setq pt2 (list (nth 3 intersect_probe) (nth 4 intersect_probe) (nth 5 intersect_probe)))
(setq length_1 (vlax-curve-getDistAtPoint vla_curve pt1))
(setq length_2 (vlax-curve-getDistAtPoint vla_curve pt2))
(setq diff_length (abs (- length_1 length_2)))
(setq full_length (vlax-curve-getDistAtParam vla_curve (vlax-curve-getEndParam vla_curve )))

(if (>= (/ full_length 2) diff_length)
(progn
(setq pt3 (vlax-curve-getPointAtDist vla_curve (/(+ length_1 length_2) 2)))
); progn
); if

(if (< (/ full_length 2) diff_length)
(progn
(setq true_length length_1)
(if (> length_1 length_2)
(progn
(setq true_length length_2)
); progn
); if
(setq pt3 (vlax-curve-getPointAtDist vla_curve (- true_length 100)))
); progn
); if

(setq true_break_list (append true_break_list (list (car break_list))))
(setq break_list (cdr break_list))
(setq pt3_list (append pt3_list (list pt3)))
); progn double points
); if double points


(if (/= (length intersect_probe) 6)
(progn
(setq break_list (cdr break_list))
); 
); 


 ); while 
 (setq pt3_back pt3_list)

 (setq break_list break_back)
 (setq pt3_back pt3_list)

(defun c:pj_4 ( / *error* sel val var )
        (defun *error* ( msg )
        (mapcar '(lambda ( a b ) (if b (setvar a b))) var val)
        (LM:endundo (LM:acdoc))
        (if (and msg (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*")))
            (princ (strcat "\nError: " msg))
        )
        (princ)
    )
    (LM:startundo (LM:acdoc))
            (setq var '(cmdecho peditaccept)
                  val  (mapcar 'getvar var)
            )
            (mapcar '(lambda ( a b c ) (if a (setvar b c))) val var '(0 1))
            (command "_.pedit" "_m" sel_set "" "_j" "" "")
    (*error* nil)
    (princ)
)
(defun LM:ssget ( msg arg / sel )
    (princ msg)
    (setvar 'nomutt 1)
    (setq sel (vl-catch-all-apply 'ssget arg))
    (setvar 'nomutt 0)
    (if (not (vl-catch-all-error-p sel)) sel)
)
(defun LM:startundo ( doc )
    (LM:endundo doc)
    (vla-startundomark doc)
)
(defun LM:endundo ( doc )
    (while (= 8 (logand 8 (getvar 'undoctl)))
        (vla-endundomark doc)
    )
)
(defun LM:acdoc nil
    (eval (list 'defun 'LM:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
    (LM:acdoc)
)
(vl-load-com) (princ)


(setq ent_last_for_fit (entlast))

 (if (> (length pt3_list) 0)
   (progn

   (setq ent_last_0 (entlast))
   (setq proba_fit 0)

   (command "_.trim" (nth 0 true_break_list) ""  (nth 0 pt3_list) "")
   (setq total_ent_list (append total_ent_list (list (entlast))))
   (setq sel_set (ssadd))
   (setq sel_set (getfromlast ent_last_0))



 (if (not sel_set)
 (setq sel_set (ssadd))
 )

   (ssadd ent_last_0 sel_set)


   (c:pj_4)

 ;;; 
   (setq true_break_list (cdr true_break_list))
   (setq pt3_list (cdr pt3_list))

           ;(alert "cut 00")
   (while (> (length pt3_list) 0)
   (setq proba_fit 1)
   (setq ent_last (entlast))
  

   (command "_.trim" (nth 0 true_break_list) ""  (nth 0 pt3_list) "")

               (setq total_ent_list (append total_ent_list (list (entlast))))

   (setq sel_set (getfromlast ent_last))

   (if (not sel_set)
 (setq sel_set (ssadd))
 )
   (ssadd ent_last sel_set)

   (c:pj_4)
   (setq true_break_list (cdr true_break_list))
   (setq pt3_list (cdr pt3_list))
  ); while
    (c:pj_4)

  ); progn
 ); if
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;; DELETE BREAK LINES ;;;

; (while (> (length break_back) 0)
; (entdel (nth 0 break_back))
; (setq break_back (cdr break_back))
; ); while


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;(alert "delete break")
; ;;;;;; SPLINE FIT ;;;;;;
; (if (= proba_fit 1)
; (setq sel_set_fit (getfromlast ent_last_for_fit))
; )
;   (if (not sel_set_fit)
; (setq sel_set_fit (ssadd))
; )
;                        ;     (alert "cut 11111ssss11")
; (ssadd ent_last_for_fit sel_set_fit)
;                          ; (alert "cut 11111ssss11")
; (setq sel_set_fit_counter 0)


; (repeat (sslength sel_set_fit)
; (command "_.pedit" (ssname sel_set_fit sel_set_fit_counter) "_Spline" "")

;               (setq total_ent_list (append total_ent_list (list (ssname sel_set_fit sel_set_fit_counter) )))

; (setq sel_set_fit_counter (+ sel_set_fit_counter 1))
; ); repeat



;(alert "regi")
;;;;;;;;;;;;;;;;;;;;;;;;
    ); progn AUTO TRIM REGION
); if AUTO TRIM REGION

); progn
); if




    (setq total_fit (ssadd (entlast) total_fit))  
    (setq total_ent_list (append total_ent_list (list (entlast))))
    (setq explode_counter (+ explode_counter 1))

     ); repeat

      (setq
        str   (car symbol_list)
        file  (strcat (getvar 'dwgprefix)  "_mylt.lin")
        fn    (open file "w")
      ); setq


            (write-line (strcat "*" str ", ---" str "---") fn)
            (write-line (strcat "A,1.5,-0.05,[\""str"\",STANDARD,S=0.1,U=0.0,X=-0.0,Y=-.05],"(rtos (* -0.1 (strlen str))2 3)) fn)
      (close fn)


      (if (= (tblsearch "LTYPE" str) nil)
        (command "_.linetype" "_load" "*" file "")
      ); end if

      (vl-file-delete file)

;; GOO 

(setq fit_counter 0)
(repeat (sslength total_fit)
     (command "_.pedit" (ssname total_fit fit_counter) "_L" "_On" "")
      (command "._CHANGE" (ssname total_fit fit_counter) "" "_Properties" "_LType" str "")
      (command "._CHANGE" (ssname total_fit fit_counter) "" "_Properties" "_LtScale" (car scale_list) "")
      (command "._CHANGE" (ssname total_fit fit_counter) "" "_Properties" "_Color" (car color_list) "")



 (command "_.pedit" (ssname total_fit fit_counter) "_Spline" "");; OFF
 (setq fit_counter (+ fit_counter 1))
); repeat fit

);progn
);if














(if (= (cdr (cadr (entget (ssname areas 1)))) "LINE")
  (progn
    (setq trim_proba 1)
    ;(alert "one")
    (command "_.pedit" "_m" (getfromlast el) "" "_Y" "_J" "" "")




 (setq
        str   (car symbol_list)
        file  (strcat (getvar 'dwgprefix)  "_mylt.lin")
        fn    (open file "w")
      ); setq

      (write-line (strcat "*" str ", ---" str "---") fn)

            (write-line (strcat "A,1.5,-0.05,[\""str"\",STANDARD,S=0.1,U=0.0,X=-0.0,Y=-.05],"(rtos (* -0.012 (strlen str)) 2 3)) fn)
      (close fn)
        ;(setvar 'expert 5)

      (if (= (tblsearch "LTYPE" str) nil)
        (command "_.linetype" "_load" "*" file "")
      ); end if

      (vl-file-delete file)


    (setq closed_pline (getfromlast el_2))
    (setq closed_pline_counter 0)

    (repeat (sslength closed_pline)
            (if (= auto_trim 0)
    (command "_.pedit" (ssname closed_pline closed_pline_counter) "_Spline" "")
    )








    (command "_.pedit" (ssname closed_pline closed_pline_counter) "_L" "_On" "")


      (command "._CHANGE" (ssname closed_pline closed_pline_counter) "" "_Properties" "_LType" str "")
      (command "._CHANGE" (ssname closed_pline closed_pline_counter) "" "_Properties" "_LtScale" (car scale_list) "")
      (command "._CHANGE" (ssname closed_pline closed_pline_counter) "" "_Properties" "_Color" (car color_list) "")
                     (setq total_ent_list (append total_ent_list (list (entlast))))
      (setq closed_pline_counter (+ closed_pline_counter 1))

    ); repeat

    ); progn 
  ); if



      (if (/= (cdr color_list) nil)
        (setq color_list (cdr color_list))
      ); end if

      (if (/= (cdr scale_list) nil)
        (setq scale_list (cdr scale_list))
      ); end if

                  (if (/= (cdr scale_list) nil)
        (setq scale_list (cdr scale_list))
      ); end if

            (if (/= (cdr width_list) nil)
        (setq width_list (cdr width_list))
      ); end if

            (if (/= (cdr symbol_list) nil)
        (setq symbol_list (cdr symbol_list))
      ); end if

  (princ)
)  ;;;; end MP





(c:mp) 
   ; (setq total_ent_list (append total_ent_list (list (entlast))))
      





;;;;;;;;;;;;;;;;;  BEGIAN AUTO TRIM ;;;;;;;;;;;;;;;;;

(setq ent_curve (entlast))
;(alert "next file")

(if (= auto_trim 1)

  (progn

(if (= trim_proba 1)
  (progn
(setq vla_curve (vlax-ename->vla-object ent_curve))
(setq  pt3_list '())

(setq true_break_list '())
(setq sel_set_fit (ssadd))
(setq sel_set (ssadd))
;;;; FIND CURVE AND POINTS ;;;;;;;
(while (> (length break_list) 0)
  ;(alert "next pt3")
(setq temp_line (vlax-ename->vla-object (car break_list)))
(setq intersect_probe (vlax-invoke vla_curve 'IntersectWith temp_line acextendnone))

(if (= (length intersect_probe) 6)
(progn
(setq pt1 (list (nth 0 intersect_probe) (nth 1 intersect_probe) (nth 2 intersect_probe)))
(setq pt2 (list (nth 3 intersect_probe) (nth 4 intersect_probe) (nth 5 intersect_probe)))
(setq length_1 (vlax-curve-getDistAtPoint vla_curve pt1))
(setq length_2 (vlax-curve-getDistAtPoint vla_curve pt2))
(setq diff_length (abs (- length_1 length_2)))
(setq full_length (vlax-curve-getDistAtParam vla_curve (vlax-curve-getEndParam vla_curve )))

(if (>= (/ full_length 2) diff_length)
(progn
(setq pt3 (vlax-curve-getPointAtDist vla_curve (/(+ length_1 length_2) 2)))
); progn
); if
(if (< (/ full_length 2) diff_length)
(progn
(setq true_length length_1)
(if (> length_1 length_2)
(progn
(setq true_length length_2)
); progn
); if
(setq pt3 (vlax-curve-getPointAtDist vla_curve (- true_length 100)))
); progn
); if
(setq true_break_list (append true_break_list (list (car break_list))))
(setq break_list (cdr break_list))
(setq pt3_list (append pt3_list (list pt3)))
); progn double points
); if double points


(if (/= (length intersect_probe) 6)
(progn
(setq break_list (cdr break_list))
); 
); 


); while 
(setq pt3_back pt3_list)

(setq break_list break_back)
(setq pt3_back pt3_list)

(defun c:pj_4 ( / *error* sel val var )
        (defun *error* ( msg )
        (mapcar '(lambda ( a b ) (if b (setvar a b))) var val)
        (LM:endundo (LM:acdoc))
        (if (and msg (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*")))
            (princ (strcat "\nError: " msg))
        )
        (princ)
    )
    (LM:startundo (LM:acdoc))
            (setq var '(cmdecho peditaccept)
                  val  (mapcar 'getvar var)
            )
            (mapcar '(lambda ( a b c ) (if a (setvar b c))) val var '(0 1))
            (command "_.pedit" "_m" sel_set "" "_j" "" "")
    (*error* nil)
    (princ)
)
(defun LM:ssget ( msg arg / sel )
    (princ msg)
    (setvar 'nomutt 1)
    (setq sel (vl-catch-all-apply 'ssget arg))
    (setvar 'nomutt 0)
    (if (not (vl-catch-all-error-p sel)) sel)
)
(defun LM:startundo ( doc )
    (LM:endundo doc)
    (vla-startundomark doc)
)
(defun LM:endundo ( doc )
    (while (= 8 (logand 8 (getvar 'undoctl)))
        (vla-endundomark doc)
    )
)
(defun LM:acdoc nil
    (eval (list 'defun 'LM:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
    (LM:acdoc)
)
(vl-load-com) (princ)


(setq ent_last_for_fit (entlast))

(if (> (length pt3_list) 0)
  (progn

  (setq ent_last_0 (entlast))
  (setq proba_fit 0)

  (command "_.trim" (nth 0 true_break_list) ""  (nth 0 pt3_list) "")
             (setq total_ent_list (append total_ent_list (list (entlast))))
  (setq sel_set (ssadd))
  (setq sel_set (getfromlast ent_last_0))



(if (not sel_set)
(setq sel_set (ssadd))
)

  (ssadd ent_last_0 sel_set)


  (c:pj_4)

;;; 
  (setq true_break_list (cdr true_break_list))
  (setq pt3_list (cdr pt3_list))

          ;(alert "cut 00")
  (while (> (length pt3_list) 0)

  (setq proba_fit 1)
  (setq ent_last (entlast))
  

  (command "_.trim" (nth 0 true_break_list) ""  (nth 0 pt3_list) "")

              (setq total_ent_list (append total_ent_list (list (entlast))))

  (setq sel_set (getfromlast ent_last))

  (if (not sel_set)
(setq sel_set (ssadd))
)
  (ssadd ent_last sel_set)

  (c:pj_4)
  (setq true_break_list (cdr true_break_list))
  (setq pt3_list (cdr pt3_list))
  ); while
    (c:pj_4)

  ); progn
); if
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;; DELETE BREAK LINES ;;;

(while (> (length break_back) 0)
(entdel (nth 0 break_back))
(setq break_back (cdr break_back))
); while


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(alert "delete break")
;;;;;; SPLINE FIT ;;;;;;
(if (= proba_fit 1)
(setq sel_set_fit (getfromlast ent_last_for_fit))
)
  (if (not sel_set_fit)
(setq sel_set_fit (ssadd))
)
                       ;     (alert "cut 11111ssss11")
(ssadd ent_last_for_fit sel_set_fit)
                         ; (alert "cut 11111ssss11")
(setq sel_set_fit_counter 0)


(repeat (sslength sel_set_fit)
(command "_.pedit" (ssname sel_set_fit sel_set_fit_counter) "_Spline" "")

              (setq total_ent_list (append total_ent_list (list (ssname sel_set_fit sel_set_fit_counter) )))

(setq sel_set_fit_counter (+ sel_set_fit_counter 1))
); repeat

;;;;;;;;;;;;;;;;;;;;;;;;
    ); progn AUTO TRIM
); if AUTO TRIM
); trim proba
); trim proba









      ); END FILE CYCLE!!!

;(alert "DONE")
(c:DInfo)


(setq del_merge_counter 0)
(repeat (length total_merge_vpp_list)
(entdel (nth del_merge_counter total_merge_vpp_list))
(setq del_merge_counter (+ del_merge_counter 1))
)
(setq total_merge_vpp_list '())



      ); end progn --- empty select
    ); end if --- empty select


;;;; DELETE TEMP LIST FILES
;(alert "delete")
(if (= delete_files 1)
(progn
     (setq true_list (list "60dB.txt" "65dB.txt" "70dB.txt" "75dB.txt" "80dB.txt" "85dB.txt" "90dB.txt" "95dB.txt" "100dB.txt"))
     (setq temp_list (vl-directory-files (strcat "C:\\fly\\data\\" group_number "\\" action "\\")  "*" 1))

(defun LM:ListDifference ( l1 l2 )
  (vl-remove-if '(lambda ( x ) (member x l2)) l1)
)
(setq diff (LM:ListDifference temp_list true_list))
(setq delete_list '())
(while (>(length diff) 0)
(setq delete_list (append delete_list (list (strcat "C:\\fly\\data\\" group_number "\\" action "\\" (nth 0 diff))) ))
(setq diff (LM:ListDifference diff (list (nth 0 diff))))
)
(mapcar 'vl-file-delete delete_list)
); progn
); if
;;;;;;;;;
















;;;;;;;;; RESET DEFAULT SETTING;;;;;
    (setvar "CMDECHO" oldEcho)
    (setvar "OSMODE" oldOsm)

  (princ)






  ); END SAMPLE


(defun rem_list (lst)
  (if (car lst)
    (cons (car lst) (rem_list (vl-remove (car lst) (cdr lst))))
  )
)


(defun c:eco_clean (/)
(setq total_ent_list (rem_list total_ent_list))
(while (/= (length total_ent_list) 0)
 (if (/= (length (entget (nth 0 total_ent_list))) 0)
 (progn
     (entdel (nth 0 total_ent_list))
 ); progn
 ); if
(setq total_ent_list (cdr total_ent_list))
)
); eco_clean


(defun c:eco_hide (/)
(setq ss total_fit)
      (setq n 99);
      (setq n (list (cons 440 (+ (lsh 2 24) (fix (- 255 (* n 2.55)))))))
  

    (repeat (setq i (sslength ss))
      (entmod
        (append
          (entget (ssname ss (setq i (1- i))))
          n
          )
        )
    )
); eco_hide

(defun c:eco_save (/)
(setq total_ent_list '())
)


(setq 
  areas_2 nil
  ss_2 nil
  el_2 nil
)

(defun c:mpu( / )
  
  (defun getfromlast_2(e / s)
    (setq
     s (ssadd)
    )
      (while (setq e (entnext e))
        (setq
          s (ssadd e s)
        )
      )
  )

  (setq  ss_2 (ssget (list (cons 0 "*POLYLINE"))))
   ;(setq ss total_sel)
   (setq el_2 (entlast))
  
  (command "_.region" ss_2 "")  
  (command "_.union" (getfromlast_2 el_2) "")

  (setq el_2 (entlast))
  (command "_.explode" (entlast) )  


(setq areas (getfromlast_2 el_2))
(setq explode_counter_2 0)



(if (= (cdr (cadr (entget (ssname areas_2 1)))) "_REGION")
  (progn
    ;(alert "men2")
(repeat (sslength areas_2)
(setq el_2 (entlast))
(command "_.explode" (ssname areas_2 explode_counter_2))
(command "_.pedit" (entlast) "_y" "_j" (getfromlast_2 el_2) "" "")  
(setq explode_counter_2 (+ explode_counter_2 1))
)
);progn
);if
 
(if (= (cdr (cadr (entget (ssname areas_2 1)))) "_LINE")
  (progn
  ;  (alert "one")
    (command "_.pedit" (entlast) "_y" "_j" (getfromlast_2 el_2) "" "")
)
  )
 ; (command ".union" (getfromlast el)  "")  

  (princ)
) 

(defun round (num dp / fac)
  (setq fac (float (expt 10 dp)))

  (if (< 0.5 (rem (setq num (* fac num)) 1))
    (/ (1+ (fix num)) fac)
    (/     (fix num)  fac))
 )























(defun make_list (custom_level /)

  (setq file_list (list 60 65 70 75 80 85 90 95 100))

    (if (not (member custom_level file_list))
        (progn
(setq file_list (append file_list (list custom_level)))
(setq sort_file_list (vl-sort file_list '<))
(setq db_position (vl-position custom_level sort_file_list))
(setq file_list_length (vl-list-length sort_file_list))
(setq opened_file_db_custom_level (open (strcat "C:\\fly\\data\\" group_number "\\" action "\\" (itoa custom_level) "dB.txt" ) "w"))
(if (/= db_position 0)
    (progn
(if (/= db_position (- file_list_length 1))
  (progn




(setq opened_file_approx_1_count (open (strcat "C:\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (- db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq opened_file_approx_2_count (open (strcat "C:\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (+ db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq file_length_1 0)
(setq file_length_2 0)
; (setq alpha_list (list ))

(while (read-line opened_file_approx_1_count)

(setq file_length_1 (+ 1 file_length_1))
)
(while (read-line opened_file_approx_2_count)

(setq file_length_2 (+ 1 file_length_2))
)

(close opened_file_approx_1_count)
(close opened_file_approx_2_count)


(setq dNtoDel (- file_length_1 file_length_2))

(setq dNtoDel_list (append dNtoDel_list (list dNtoDel)))



(setq opened_file_approx_1 (open (strcat "C:\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (- db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq opened_file_approx_2 (open (strcat "C:\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (+ db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq delta_level (- (nth (+ db_position 1) sort_file_list) custom_level) )

(setq delete_number (- custom_level (nth (- db_position 1) sort_file_list)) )

(setq true_sum 0)
(setq false_sum 0)
(setq proba_number 0)
(setq number_to_write_counter 0)
(setq delta_counter split_number)

(setq alpha (/ (float delta_level) delta_counter))
;(setq alpha_list (append alpha_list (list alpha )))
(while (setq sum_k (read-line opened_file_approx_1))

(setq true_sum2 0)
(if (setq sum_k_1 (read-line opened_file_approx_2))
    (progn
(setq true_sum2 1)
(setq last_sum_k_1 sum_k_1)

(setq med (+ (* alpha (atof sum_k)) (* (- 1 alpha) (atof sum_k_1))))
(setq true_sum (+ 1 true_sum))

(write-line (rtos med) opened_file_db_custom_level)
); progn sum2 no 0
); if sum2 not 0

(if (= true_sum2 0)
(progn
 (setq number_to_write (fix (* dNtoDel alpha)))

(if (< number_to_write_counter number_to_write)
(progn
;(alert "add")
(setq number_to_write_counter (+ 1 number_to_write_counter))
 (setq med (+ (* alpha (atof sum_k)) (* (- 1 alpha) (atof last_sum_k_1))))
 (setq false_sum (+ 1 false_sum))

(write-line (rtos med) opened_file_db_custom_level)

) ; progn
); if
); progn
); if


); while


(close opened_file_approx_1)
(close opened_file_approx_2)


); progn poi\sition not end
); if positiom not end
); progn
); if






















(if (= db_position 0)
(progn
(setq opened_file_approx_1 (open (strcat "C:\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (+ db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq step_from_less ( - (nth (+ db_position 1) sort_file_list) custom_level))
(setq coeff (+ 1 (*(/ (float step_from_less) 100) 3)))
(while (setq sum1 (read-line opened_file_approx_1))

(setq med (*(atoi sum1) coeff ))
(write-line (rtos med) opened_file_db_custom_level)
); while
(close opened_file_approx_1)
    ); progn position 0
); if position 0

(if (= db_position (- file_list_length 1))
(progn

(setq opened_file_approx_1 (open (strcat "C:\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (- db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq step_from_less (- custom_level (nth (- db_position 1) sort_file_list)))
(setq coeff (- 1 (*(/ (float step_from_less) 100) 3)))
(while (setq sum1 (read-line opened_file_approx_1))

(setq med (* (float (atoi sum1)) coeff ))
    (write-line (rtos med) opened_file_db_custom_level)
); while
(close opened_file_approx_1)
); progn position end
); if position end


(close opened_file_db_custom_level) 


)
;(alert "add")
        ); progn not in list 60 65 70..
    

(setq file_list (vl-remove custom_level file_list))
;(setq file_list (append file_list (list custom_level)))

    )