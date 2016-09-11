; (repeat (- (setq region_length (length main_naeb)) 1)
; (command "_.union"   (car main_naeb) (cadr main_naeb) "")
; (setq temp_region (entlast))
; (subst temp_region (car main_naeb) main_naeb)
; (vl-remove (cadr main_naeb) main_naeb)
; )

(command "_.UNION")
(apply 'command main_naeb);
(command "")

(command "_COLOR" (itoa (caddr _list)))