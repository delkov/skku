(defun c:sper(/ spSet ptLst Dr Ang sCurve oldEcho
          oldOsm dataLst fPt curLen Ans)
 
 ; (vl-load-com)


(defun begin_activex ( / )
  (vl-load-com)
  (setq acad_application (vlax-get-acad-object))
  (setq active_document (vla-get-ActiveDocument acad_application))
  (setq model_space (vla-get-ModelSpace active_document))
  (setq paper_space (vla-get-PaperSpace active_document))
); defun begin_activex

    (defun *error* (msg)
    (setvar "CMDECHO" oldEcho)
    (setvar "OSMODE" oldOsm)
    (princ)
    ); end of *error*
 
 ; (setq space(vlax-get adoc
 ; (if (equal (getvar "cvport") 1) 
 ; 'PaperSpace
 ; 'ModelSpace
 ; );_if
 ; )
 ; );_setq

    (setq oldEcho(getvar "CMDECHO")
          oldOsm(getvar "OSMODE")
          ); end setq
  (setvar "CMDECHO" 0)





  (princ "\n<<< Select Spline >>>")
  (if
    (setq spSet
      (ssget "_:S" '((0 . "SPLINE"))))
    (progn
      (setq  ptLst


        (mapcar 'cdr
         (vl-remove-if
              '(lambda(x)(/= (car x) 11))
                (entget(ssname spSet 0))))



       sCurve(vlax-ename->vla-object
          (ssname spSet 0))
       dataLst '()
       end_point nil
       start_point nil
       curLen T
       ); end setq
      (setvar "OSMODE" 0)

     (setq counter_test 1);
     (setq step 10);
     (setq temp_length 0)
     (setq point_list (list ))
     (setq spline_length (vlax-curve-getDistAtPoint sCurve (vlax-curve-getEndPoint sCurve)));
     ;(while (< (- spline_length temp_length) 0 )
     (setq true_count (/ spline_length step))
     (setq ok_point 1)


(setq ff (open "C:\\Users\\delko_000\\Desktop\\temp.txt" "r"))
(setq trash_line (read-line ff))



    (while (and (> ok_point 0) (< counter_test true_count))
      (setq probe_line (read-line ff))
      (if (= probe_line ())
      (setq ok_point 0)
      )


      (setq counter_test (+ counter_test 1))
      (setq temp_length (+ temp_length step))
      (setq point_list (append point_list (list  (vlax-curve-getPointAtDist sCurve temp_length)))) 
      ;(setq perp_length (append perp_length list(probe_line)))
    )



     ;(setq point_list (append point_list (list  (vlax-curve-getPointAtDist sCurve 10)))) 








      (foreach pt point_list
   (setq Dr(vlax-curve-getFirstDeriv sCurve
              (vlax-curve-getParamAtPoint sCurve pt))
         Ang(- pi(atan(/(car Dr)(cadr Dr))))
         dataLst(append dataLst
            (list(list(trans pt 0 1) Ang))); perp_length)
         ); end setq
   ); end foreach
  


      (setq counter 0)



      
       (while dataLst
    (setq curLen 10
        
          fPt(caar dataLst)
          Ang(cadar dataLst)
          ;perp_length(caddr dataLst)
          ); end setq

     (if (= counter 0)
    
     (progn

 (setq double_der (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve fPt)));
;(alert double_der)
  (if (> (cadr double_der) 0)
    (progn
    
      (command "_.line" fPt 
     (trans(polar fPt  (+ Ang 0.78)  curLen)0 1)"")
     (setq temp_line (vlax-ename->vla-object (entlast)))
     (setq start_angle_point (list (vlax-curve-getEndPoint temp_line)))


     (command "_.line" fPt 
     (trans(polar fPt   (+ Ang 1.56)   curLen)0 1)"")
     (setq temp_line (vlax-ename->vla-object (entlast)))
     (setq med_angle_point (list (vlax-curve-getEndPoint temp_line)))


     (command "_.line" fPt 
    (trans(polar fPt  (+ Ang 2.34)  curLen)0 1)"")
     (setq temp_line (vlax-ename->vla-object (entlast)))
     (setq end_angle_point (list (vlax-curve-getEndPoint temp_line)))

 )   
)

  (if (<= (cadr double_der) 0)
    (progn
    
      (command "_.line" fPt 
     (trans(polar fPt  (- Ang 2.34)  curLen)0 1)"")
     (setq temp_line (vlax-ename->vla-object (entlast)))
     (setq start_angle_point (list (vlax-curve-getEndPoint temp_line)))


     (command "_.line" fPt 
     (trans(polar fPt   (- Ang 1.56)   curLen)0 1)"")
     (setq temp_line (vlax-ename->vla-object (entlast)))
     (setq med_angle_point (list (vlax-curve-getEndPoint temp_line)))


     (command "_.line" fPt 
    (trans(polar fPt  (- Ang 0.78)  curLen)0 1)"")
     (setq temp_line (vlax-ename->vla-object (entlast)))
     (setq end_angle_point (list (vlax-curve-getEndPoint temp_line)))

     )
    )



      ); progn
            );

; (if (< Ang 0)
;   (progn
    
;     (command "_.line" fPt 
;     (trans(polar fPt  (+ Ang 0)  curLen)0 1)"")
;     (setq temp_line (vlax-ename->vla-object (entlast)))
;     (setq start_angle_point (list (vlax-curve-getEndPoint temp_line)))


;     (command "_.line" fPt 
;     (trans(polar fPt   (+ Ang 0)   curLen)0 1)"")
;     (setq temp_line (vlax-ename->vla-object (entlast)))
;     (setq med_angle_point (list (vlax-curve-getEndPoint temp_line)))


;     (command "_.line" fPt 
;     (trans(polar fPt  (+ Ang 0)  curLen)0 1)"")
;     (setq temp_line (vlax-ename->vla-object (entlast)))
;     (setq end_angl_point (list (vlax-curve-getEndPoint temp_line)))

    

;     ); progn
;     );




;     ); progn
;     ); if

    (if curLen
      (progn

    (if (< (cadr (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve fPt))) 0)
      (progn
    (command "_.line" fPt

      
         (trans(polar fPt Ang curLen)0 1) (trans(polar fPt (- Ang Pi) curLen)0 1) "")
        (setq temp_line (vlax-ename->vla-object (entlast)))
        (setq end_point (append end_point (list (vlax-curve-getEndPoint temp_line))))  
        (setq start_point (append start_point (list (vlax-curve-getStartPoint temp_line))))
      )
      ); end if


        (if (>= (cadr (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve fPt))) 0)
      (progn
    (command "_.line" fPt

      
         (trans(polar fPt Ang curLen)0 1) (trans(polar fPt (- Ang Pi) curLen)0 1) "")
        (setq temp_line (vlax-ename->vla-object (entlast)))
        (setq end_point (append end_point (list (vlax-curve-getStartPoint temp_line))))  
        (setq start_point (append start_point (list (vlax-curve-getEndPoint temp_line))))
      )
      ); end if


    ;(initget "Yes No")
    ;(setq Ans(getkword "\n>>> Mirror line? [Yes/No] <No>: "))
    ;(if(null Ans)(setq Ans "No"))
    ;(if(= Ans "Yes")
     ; (progn
      ;  (command "_.erase" (entlast) "")
       ; (command "_.line" fPt
        ; (trans(polar fPt(- Ang Pi)curLen)0 1)"")
        ;); end progn
      ;); end if

        ; (setq temp_line (vlax-ename->vla-object (entlast)))

        ; (if
        ;   (> (cadr (vlax-curve-getEndPoint temp_line)) (cadr (vlax-curve-getStartPoint temp_line)))
        ;   (progn
        ;   (setq end_point (append end_point (list (vlax-curve-getStartPoint temp_line))))  
        ;   (setq start_point (append start_point (list (vlax-curve-getEndPoint temp_line))))
        ;   );
        ; ); if

        ; (if
        ;   (<= (cadr (vlax-curve-getEndPoint temp_line)) (cadr (vlax-curve-getStartPoint temp_line)))
        ;   (progn
        ;   (setq end_point (append end_point (list (vlax-curve-getEndPoint temp_line))))  
        ;   (setq start_point (append start_point (list (vlax-curve-getStartPoint temp_line))))
        ;   );

        )
        ); if




    (setq dataLst(cdr dataLst))
    (if(not dataLst)
      (princ "\n*** End of Spline. Quit. ***")
      ); end if
    (setq counter (+ counter 1))
    ); end while
     (if (= ok_point 1)
     (setq point_list (append point_list (list (vlax-curve-getEndPoint sCurve))))
     )

(close ff)
(setq ff nil)



        ;(setq stpt (vlax-3d-point '(0.0 0.0 0.0)));_start pt for spline
       ; (setq ept (vlax-3d-point '(0.0 0.0 0.0)));_end pt for spline
       ; (setq total_point (append start_angle_point start_point (reverse end_point) med_angle_point start_angle_point))
       ;(setq total_point (append med_angle_point start_point (reverse end_point) med_angle_point  ))
        (setq total_point (append med_angle_point end_angle_point start_point (reverse end_point) start_angle_point med_angle_point  ))
        ; (setq array (vlax-make-safearray vlax-vbDouble (cons 1 (length total_point)))) 
        ; (vlax-safearray-fill array total_point)
        ; (setq spline (vla-AddLightWeightPolyline model_space array))


(entmake
       (append
         (list
           '(0 . "SPLINE")
           '(100 . "AcDbEntity")
           '(100 . "AcDbSpline")
           '(70 . 40)
           '(71 . 3)
           (cons 74 (length total_point))
           '(44 . 1.0e-005)
           )
         (mapcar '(lambda (x) (cons 11 x)) total_point)
         )
       )



      ); end progn
    ); end if



    (setvar "CMDECHO" oldEcho)
    (setvar "OSMODE" oldOsm)
  (princ)
  ); end of c:sper